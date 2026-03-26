# frozen_string_literal: true

# Force-load the default series_nav before overriding so all support files are required.
require "pagy/toolbox/helpers/series_nav"

class Pagy
  module NumericHelpers
    def series_nav(**)
      return "" if @last <= 1

      a = a_lambda(**)

      link_cls     = "px-3 py-1.5 text-sm text-gray-600 rounded-md hover:bg-zinc-50 transition-colors"
      current_cls  = "px-3 py-1.5 text-sm font-medium text-white bg-rose-500 rounded-md"
      nav_cls      = "px-3 py-1.5 text-sm text-gray-500 rounded-md hover:bg-zinc-50 transition-colors"
      disabled_cls = "px-2 py-1.5 text-sm text-gray-300 cursor-not-allowed"
      gap_cls      = "px-2 py-1.5 text-sm text-gray-400"

      prev_lbl = I18n.translate("pagy.previous")
      prev_aria = I18n.translate("pagy.aria_label.previous")
      prev_html = if @previous
        a.(@previous, prev_lbl, classes: nav_cls, aria_label: prev_aria)
      else
        %(<a role="link" aria-disabled="true" aria-label="#{prev_aria}" class="#{disabled_cls}">#{prev_lbl}</a>)
      end

      pages_html = series(**).map do |item|
        case item
        when Integer
          a.(item, classes: link_cls)
        when String  # current page (stringified number)
          %(<a role="link" aria-disabled="true" aria-current="page" class="#{current_cls}">#{page_label(item)}</a>)
        when :gap
          %(<span class="#{gap_cls}" role="separator" aria-disabled="true">#{I18n.translate("pagy.gap")}</span>)
        end
      end.join

      next_lbl  = I18n.translate("pagy.next")
      next_aria = I18n.translate("pagy.aria_label.next")
      next_html = if @next
        a.(@next, next_lbl, classes: nav_cls, aria_label: next_aria)
      else
        %(<a role="link" aria-disabled="true" aria-label="#{next_aria}" class="#{disabled_cls}">#{next_lbl}</a>)
      end

      wrap_series_nav(prev_html + pages_html + next_html,
                      "pagy series-nav flex items-center justify-center gap-1", **)
    end
  end
end
