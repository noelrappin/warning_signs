module WarningSigns
  class Railtie < Rails::Railtie
    initializer "warning_signs.configure" do |app|
      if File.exist?(".warning_signs.yml")
        World.from_file(".warning_signs.yml")
      end
    end
  end
end
