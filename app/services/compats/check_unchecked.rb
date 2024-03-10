module Compats
  class CheckUnchecked < Baseline::Service
    LIMIT = 100

    def call
      check_uniqueness on_error: :return

      count = 0

      RailsRelease
        .latest_major
        .reverse
        .concat(RailsRelease.all)
        .uniq
        .each do |rails_release|

        break unless count < LIMIT

        rails_release
          .compats
          .unchecked
          .limit(LIMIT - count)
          .each do |compat|

          count += 1

          begin
            Compats::Check.call compat
          rescue Compats::Check::Error => error
            ReportError.call error
          end
        end
      end
    end
  end
end
