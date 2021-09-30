# frozen_string_literal: true

require "event_parsers"

# Subscribe to event and publicate results
Decidim::EventsManager.subscribe(/^decidim\.events\./) do |event_name, data|
  parser = case event_name
           when "decidim.events.meetings.meeting_created"
             EventParsers::EventMeetingParser.new(data[:resource])
           when "decidim.events.meetings.meeting_registration_confirmed"
             EventParsers::EventRegistrationParser.new(data[:resource])
           end
  if parser
    unless parser.valid?
      Rails.logger.error "Not publishing event ##{data[:resource].id} [#{event_name}] to CiviCRM API: #{parser.errors.values}"
      break
    end

    service = EventSyncService.new(parser)

    if service.publish
      Rails.logger.info "Published event ##{data[:resource].id} [#{event_name}] to CiviCRM API with UID #{service.result["id"]}"
      # TODO: save model Assign
    else
      Rails.logger.error "Error publishing event ##{data[:resource].id} [#{event_name}] to CiviCRM API #{service.result}"
    end
  end
end
