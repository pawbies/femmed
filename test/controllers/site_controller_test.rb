require "test_helper"

class SiteControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @admin = users(:admin)
  end

  test "index" do
    # Not authenticated
    get root_url
    assert_redirected_to landing_url

    # Authenticated
    sign_in_as(@user)
    get root_url
    assert_response :success
  end

  test "landing" do
    # Not authenticated
    get landing_url
    assert_response :success

    # Authenticated
    sign_in_as(@user)
    get landing_url
    assert_response :success
  end

  test "about" do
    # Not authenticated
    get about_url
    assert_response :success

    # Authenticated
    sign_in_as(@user)
    get about_url
    assert_response :success
  end

  test "timeline: access and date parsing" do
    # Not authenticated
    get timeline_url
    assert_redirected_to new_session_url

    sign_in_as(@user)

    # Authenticated
    get timeline_url
    assert_response :success

    # Default to today when no date given
    assert_equal Date.today, assigns(:date)

    # Parse a valid date param
    get timeline_url, params: { date: "2026-01-15" }
    assert_equal Date.new(2026, 1, 15), assigns(:date)

    # Fallback to today for invalid date param
    get timeline_url, params: { date: "not-a-date" }
    assert_equal Date.today, assigns(:date)

    # Future dates are accessible (no redirect)
    get timeline_url, params: { date: Date.tomorrow.iso8601 }
    assert_response :success
    assert_equal Date.tomorrow, assigns(:date)
  end

  test "timeline: doses always appear" do
    sign_in_as(@user)
    date = Date.new(2026, 3, 1)

    # Prescription with no routine — dose always shows
    dose_no_routine = prescriptions(:alice_percocet).doses.create!(
      amount_taken: 1,
      taken_at: date.beginning_of_day + 10.hours
    )

    # Prescription with a routine — dose still shows even when taken outside routine window
    schedule = IceCube::Schedule.new(date.beginning_of_day)
    schedule.add_recurrence_rule IceCube::Rule.daily.hour_of_day(8).minute_of_hour(0)
    prescriptions(:alice_ritalin_ir).update!(routine: schedule)

    dose_with_routine = prescriptions(:alice_ritalin_ir).doses.create!(
      amount_taken: 1,
      taken_at: date.beginning_of_day + 15.hours  # far from 08:00
    )

    get timeline_url, params: { date: date.iso8601 }

    assert_includes assigns(:doses_by_hour)[10], dose_no_routine
    assert_includes assigns(:doses_by_hour)[15], dose_with_routine
  end

  test "timeline: planned occurrence shown when no dose taken nearby" do
    sign_in_as(@user)
    date = Date.new(2026, 3, 2)

    schedule = IceCube::Schedule.new(date.beginning_of_day)
    schedule.add_recurrence_rule IceCube::Rule.daily.hour_of_day(8).minute_of_hour(0)
    prescriptions(:alice_ritalin_ir).update!(routine: schedule)

    get timeline_url, params: { date: date.iso8601 }

    planned = assigns(:planned_by_hour)[8]
    assert planned.any?, "expected a planned entry at 08:00"
    assert_equal prescriptions(:alice_ritalin_ir), planned.first[:prescription]
  end

  test "timeline: planned occurrence suppressed when dose taken within 1 hour" do
    sign_in_as(@user)
    date = Date.new(2026, 3, 3)

    schedule = IceCube::Schedule.new(date.beginning_of_day)
    schedule.add_recurrence_rule IceCube::Rule.daily.hour_of_day(8).minute_of_hour(0)
    prescriptions(:alice_ritalin_ir).update!(routine: schedule)

    # Dose taken 30 minutes after the scheduled time
    prescriptions(:alice_ritalin_ir).doses.create!(
      amount_taken: 1,
      taken_at: date.beginning_of_day + 8.hours + 30.minutes
    )

    get timeline_url, params: { date: date.iso8601 }

    assert assigns(:planned_by_hour)[8].empty?, "planned entry should be suppressed"
    assert assigns(:doses_by_hour)[8].any?, "actual dose should still appear"
  end

  test "timeline: planned occurrence shown when dose taken more than 1 hour away" do
    sign_in_as(@user)
    date = Date.new(2026, 3, 4)

    schedule = IceCube::Schedule.new(date.beginning_of_day)
    schedule.add_recurrence_rule IceCube::Rule.daily.hour_of_day(8).minute_of_hour(0)
    prescriptions(:alice_ritalin_ir).update!(routine: schedule)

    # Dose taken 2 hours after the scheduled time
    prescriptions(:alice_ritalin_ir).doses.create!(
      amount_taken: 1,
      taken_at: date.beginning_of_day + 10.hours
    )

    get timeline_url, params: { date: date.iso8601 }

    assert assigns(:planned_by_hour)[8].any?, "planned entry should still show"
    assert assigns(:doses_by_hour)[10].any?, "dose at 10:00 should appear"
  end

  test "timeline: planned occurrence suppressed exactly at 1 hour boundary" do
    sign_in_as(@user)
    date = Date.new(2026, 3, 5)

    schedule = IceCube::Schedule.new(date.beginning_of_day)
    schedule.add_recurrence_rule IceCube::Rule.daily.hour_of_day(8).minute_of_hour(0)
    prescriptions(:alice_ritalin_ir).update!(routine: schedule)

    # Dose taken exactly 1 hour after — within the window
    prescriptions(:alice_ritalin_ir).doses.create!(
      amount_taken: 1,
      taken_at: date.beginning_of_day + 9.hours
    )

    get timeline_url, params: { date: date.iso8601 }

    assert assigns(:planned_by_hour)[8].empty?, "dose exactly 1h away should suppress planned entry"
  end

  test "timeline: multiple routines, each suppressed independently" do
    sign_in_as(@user)
    date = Date.new(2026, 3, 6)

    # Two prescriptions each with a routine
    schedule_a = IceCube::Schedule.new(date.beginning_of_day)
    schedule_a.add_recurrence_rule IceCube::Rule.daily.hour_of_day(8).minute_of_hour(0)
    prescriptions(:alice_ritalin_ir).update!(routine: schedule_a)

    schedule_b = IceCube::Schedule.new(date.beginning_of_day)
    schedule_b.add_recurrence_rule IceCube::Rule.daily.hour_of_day(8).minute_of_hour(0)
    prescriptions(:alice_percocet).update!(routine: schedule_b)

    # Only take ritalin, not percocet
    prescriptions(:alice_ritalin_ir).doses.create!(
      amount_taken: 1,
      taken_at: date.beginning_of_day + 8.hours
    )

    get timeline_url, params: { date: date.iso8601 }

    planned = assigns(:planned_by_hour)[8]
    prescription_ids = planned.map { |e| e[:prescription].id }

    assert_not_includes prescription_ids, prescriptions(:alice_ritalin_ir).id,
      "ritalin planned entry should be suppressed (dose taken)"
    assert_includes prescription_ids, prescriptions(:alice_percocet).id,
      "percocet planned entry should still show (no dose taken)"
  end

  test "calendar" do
    # Not authenticated
    get calendar_url
    assert_redirected_to new_session_url

    # Authenticated
    sign_in_as(@user)
    get calendar_url
    assert_response :success

    # Month mode
    get calendar_url(mode: "month")
    assert_response :success

    # Week mode
    get calendar_url(mode: "week")
    assert_response :success
  end

  test "admin" do
    # Not authenticated
    get admin_url
    assert_redirected_to new_session_url

    # Not admin
    sign_in_as @user
    get admin_url
    assert_redirected_to root_url

    # Admin
    sign_in_as @admin
    get admin_url
    assert_response :success
  end
end
