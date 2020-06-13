# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    h1 "Donaciones"
    tabs do
      Reports::Donation.current.each_pair do |name, data|
        tab t("reports.#{name}") do
          render partial: "donation_report", locals: { report: data }
        end
      end
    end

    h1 "Produccion"
    tabs do
      Reports::Production.current.each_pair do |name, data|
        tab t("reports.#{name}") do
          render partial: "production_report", locals: { report: data }
        end
      end
    end

    h1 "Materiales"
    tabs do
      Reports::Material.current.each_pair do |name, data|
        tab t("reports.#{name}") do
          render partial: "material_report", locals: { report: data }
        end
      end
    end

    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end
  end
end
