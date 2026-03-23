require "test_helper"

class Prescriptions::RoutinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user        = users(:alice)
    @other_user  = users(:bob)
    @prescription       = prescriptions(:alice_ritalin_ir)
    @other_prescription = prescriptions(:bob_adderall_xr)
  end

  # ── Helpers ────────────────────────────────────────────────────────────────

  def daily_schedule(time: "08:00")
    schedule = IceCube::Schedule.new(Time.current.beginning_of_day)
    h, m = time.split(":").map(&:to_i)
    schedule.add_recurrence_rule IceCube::Rule.daily.hour_of_day(h).minute_of_hour(m)
    schedule
  end

  def set_routine!(schedule = daily_schedule)
    @prescription.update!(routine: schedule)
  end

  # ── new ────────────────────────────────────────────────────────────────────

  test "new: redirects when not authenticated" do
    get new_prescription_routine_url(@prescription)
    assert_redirected_to new_session_url
  end

  test "new: 404 for another user's prescription" do
    sign_in_as(@other_user)
    get new_prescription_routine_url(@prescription)
    assert_response :not_found
  end

  test "new: success for own prescription" do
    sign_in_as(@user)
    get new_prescription_routine_url(@prescription)
    assert_response :success
  end

  # ── create ─────────────────────────────────────────────────────────────────

  test "create: redirects when not authenticated" do
    post prescription_routine_url(@prescription), params: { routine_type: "daily" }
    assert_redirected_to new_session_url
  end

  test "create: 404 for another user's prescription" do
    sign_in_as(@other_user)
    post prescription_routine_url(@prescription), params: { routine_type: "daily" }
    assert_response :not_found
  end

  test "create: daily routine" do
    sign_in_as(@user)
    post prescription_routine_url(@prescription), params: {
      routine_type: "daily",
      routine_start: Date.today.to_s,
      "routine_times[]": [ "08:00" ]
    }
    assert_redirected_to prescription_path(@prescription, page: "Routine")
    @prescription.reload
    assert_not_nil @prescription.routine
    rule = @prescription.routine.recurrence_rules.first
    assert_instance_of IceCube::DailyRule, rule
  end

  test "create: daily routine stores times correctly" do
    sign_in_as(@user)
    post prescription_routine_url(@prescription), params: {
      routine_type: "daily",
      routine_start: Date.today.to_s,
      "routine_times[]": [ "08:00", "20:00" ]
    }
    assert_redirected_to prescription_path(@prescription, page: "Routine")
    @prescription.reload
    h = @prescription.routine.recurrence_rules.first.to_hash
    assert_equal [ 8, 20 ], h.dig(:validations, :hour_of_day)
    assert_equal [ 0, 0 ],  h.dig(:validations, :minute_of_hour)
  end

  test "create: interval routine" do
    sign_in_as(@user)
    post prescription_routine_url(@prescription), params: {
      routine_type: "interval",
      routine_interval: 3,
      routine_start: Date.today.to_s,
      "routine_times[]": [ "09:00" ]
    }
    assert_redirected_to prescription_path(@prescription, page: "Routine")
    @prescription.reload
    rule = @prescription.routine.recurrence_rules.first
    assert_instance_of IceCube::DailyRule, rule
    assert_equal 3, rule.to_hash[:interval]
  end

  test "create: weekly routine" do
    sign_in_as(@user)
    post prescription_routine_url(@prescription), params: {
      routine_type: "weekly",
      routine_start: Date.today.to_s,
      "routine_days[]": [ "monday", "thursday" ],
      "routine_times[]": [ "07:30" ]
    }
    assert_redirected_to prescription_path(@prescription, page: "Routine")
    @prescription.reload
    rule = @prescription.routine.recurrence_rules.first
    assert_instance_of IceCube::WeeklyRule, rule
    days = rule.to_hash.dig(:validations, :day)
    assert_includes days, Date::DAYNAMES.index("Monday")
    assert_includes days, Date::DAYNAMES.index("Thursday")
  end

  test "create: hourly routine" do
    sign_in_as(@user)
    post prescription_routine_url(@prescription), params: {
      routine_type: "hourly",
      routine_hourly_interval: 6,
      routine_start: Date.today.to_s
    }
    assert_redirected_to prescription_path(@prescription, page: "Routine")
    @prescription.reload
    rule = @prescription.routine.recurrence_rules.first
    assert_instance_of IceCube::HourlyRule, rule
    assert_equal 6, rule.to_hash[:interval]
  end

  test "create: missing routine_type renders unprocessable" do
    sign_in_as(@user)
    post prescription_routine_url(@prescription), params: {}
    assert_response :unprocessable_content
    @prescription.reload
    assert_nil @prescription.routine
  end

  test "create: weekly with no days renders unprocessable" do
    sign_in_as(@user)
    post prescription_routine_url(@prescription), params: {
      routine_type: "weekly",
      routine_start: Date.today.to_s
    }
    assert_response :unprocessable_content
    @prescription.reload
    assert_nil @prescription.routine
  end

  test "create: overwrites existing routine" do
    set_routine!
    sign_in_as(@user)
    post prescription_routine_url(@prescription), params: {
      routine_type: "hourly",
      routine_hourly_interval: 4,
      routine_start: Date.today.to_s
    }
    assert_redirected_to prescription_path(@prescription, page: "Routine")
    @prescription.reload
    assert_instance_of IceCube::HourlyRule, @prescription.routine.recurrence_rules.first
  end

  # ── edit ───────────────────────────────────────────────────────────────────

  test "edit: redirects when not authenticated" do
    set_routine!
    get edit_prescription_routine_url(@prescription)
    assert_redirected_to new_session_url
  end

  test "edit: 404 for another user's prescription" do
    set_routine!
    sign_in_as(@other_user)
    get edit_prescription_routine_url(@prescription)
    assert_response :not_found
  end

  test "edit: success for own prescription with routine" do
    set_routine!
    sign_in_as(@user)
    get edit_prescription_routine_url(@prescription)
    assert_response :success
  end

  test "edit: pre-fills daily routine data" do
    schedule = IceCube::Schedule.new(Time.current.beginning_of_day)
    schedule.add_recurrence_rule IceCube::Rule.daily.hour_of_day(9).minute_of_hour(30)
    set_routine!(schedule)

    sign_in_as(@user)
    get edit_prescription_routine_url(@prescription)
    assert_response :success
    assert_equal "daily", assigns(:routine_data)[:routine_type]
    assert_equal [ "09:30" ], assigns(:routine_data)[:routine_times]
  end

  test "edit: pre-fills interval routine data" do
    schedule = IceCube::Schedule.new(Time.current.beginning_of_day)
    schedule.add_recurrence_rule IceCube::Rule.daily(5).hour_of_day(8).minute_of_hour(0)
    set_routine!(schedule)

    sign_in_as(@user)
    get edit_prescription_routine_url(@prescription)
    assert_equal "interval",    assigns(:routine_data)[:routine_type]
    assert_equal 5,             assigns(:routine_data)[:routine_interval]
  end

  test "edit: pre-fills weekly routine data" do
    schedule = IceCube::Schedule.new(Time.current.beginning_of_day)
    schedule.add_recurrence_rule IceCube::Rule.weekly.day(:monday, :wednesday).hour_of_day(8).minute_of_hour(0)
    set_routine!(schedule)

    sign_in_as(@user)
    get edit_prescription_routine_url(@prescription)
    assert_equal "weekly", assigns(:routine_data)[:routine_type]
    assert_includes assigns(:routine_data)[:routine_days], "monday"
    assert_includes assigns(:routine_data)[:routine_days], "wednesday"
  end

  test "edit: pre-fills hourly routine data" do
    schedule = IceCube::Schedule.new(Time.current.beginning_of_day)
    schedule.add_recurrence_rule IceCube::Rule.hourly(8)
    set_routine!(schedule)

    sign_in_as(@user)
    get edit_prescription_routine_url(@prescription)
    assert_equal "hourly", assigns(:routine_data)[:routine_type]
    assert_equal 8,        assigns(:routine_data)[:routine_hourly_interval]
  end

  test "edit: works even when prescription has no routine" do
    sign_in_as(@user)
    get edit_prescription_routine_url(@prescription)
    assert_response :success
    assert_equal({}, assigns(:routine_data))
  end

  # ── update ─────────────────────────────────────────────────────────────────

  test "update: redirects when not authenticated" do
    set_routine!
    patch prescription_routine_url(@prescription), params: { routine_type: "daily" }
    assert_redirected_to new_session_url
  end

  test "update: 404 for another user's prescription" do
    set_routine!
    sign_in_as(@other_user)
    patch prescription_routine_url(@prescription), params: { routine_type: "daily" }
    assert_response :not_found
  end

  test "update: changes routine type" do
    set_routine!
    sign_in_as(@user)
    patch prescription_routine_url(@prescription), params: {
      routine_type: "hourly",
      routine_hourly_interval: 12,
      routine_start: Date.today.to_s
    }
    assert_redirected_to prescription_path(@prescription, page: "Routine")
    @prescription.reload
    assert_instance_of IceCube::HourlyRule, @prescription.routine.recurrence_rules.first
    assert_equal 12, @prescription.routine.recurrence_rules.first.to_hash[:interval]
  end

  test "update: changes times on daily routine" do
    set_routine!(daily_schedule(time: "08:00"))
    sign_in_as(@user)
    patch prescription_routine_url(@prescription), params: {
      routine_type: "daily",
      routine_start: Date.today.to_s,
      "routine_times[]": [ "12:00", "18:00" ]
    }
    assert_redirected_to prescription_path(@prescription, page: "Routine")
    @prescription.reload
    h = @prescription.routine.recurrence_rules.first.to_hash
    assert_equal [ 12, 18 ], h.dig(:validations, :hour_of_day)
  end

  test "update: missing routine_type renders unprocessable" do
    set_routine!
    sign_in_as(@user)
    patch prescription_routine_url(@prescription), params: {}
    assert_response :unprocessable_content
  end

  test "update: weekly with no days renders unprocessable" do
    set_routine!
    sign_in_as(@user)
    patch prescription_routine_url(@prescription), params: {
      routine_type: "weekly",
      routine_start: Date.today.to_s
    }
    assert_response :unprocessable_content
  end

  # ── destroy ────────────────────────────────────────────────────────────────

  test "destroy: redirects when not authenticated" do
    set_routine!
    delete prescription_routine_url(@prescription)
    assert_redirected_to new_session_url
  end

  test "destroy: 404 for another user's prescription" do
    set_routine!
    sign_in_as(@other_user)
    delete prescription_routine_url(@prescription)
    assert_response :not_found
  end

  test "destroy: removes routine and redirects" do
    set_routine!
    sign_in_as(@user)
    delete prescription_routine_url(@prescription)
    assert_redirected_to prescription_path(@prescription, page: "Routine")
    @prescription.reload
    assert_nil @prescription.routine
  end

  test "destroy: works when no routine is set" do
    sign_in_as(@user)
    delete prescription_routine_url(@prescription)
    assert_redirected_to prescription_path(@prescription, page: "Routine")
    @prescription.reload
    assert_nil @prescription.routine
  end
end
