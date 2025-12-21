require_relative '../forum_exporter'

namespace :db do
  namespace :export do
    desc 'Export all forum data to CSV and download all images'
    task forum: :environment do
      exporter = ForumExporter.new
      exporter.export!

      puts "\n✓ Export complete! Check the export/ directory for results."
      puts "  - CSV files: export/csv/"
      puts "  - Images: export/images/"
      puts "  - README: export/README.md"
    end

    desc 'Export users only'
    task users: :environment do
      puts 'Exporting users...'
      exporter = ForumExporter.new
      exporter.logger.info('Starting users-only export')
      FileUtils.mkdir_p(File.join(exporter.instance_variable_get(:@export_path), 'csv'))
      exporter.export_users
      exporter.logger.close
      puts "✓ Exported #{exporter.stats[:users]} users"
    end

    desc 'Export forum categories only'
    task categories: :environment do
      puts 'Exporting forum categories...'
      exporter = ForumExporter.new
      exporter.logger.info('Starting categories-only export')
      FileUtils.mkdir_p(File.join(exporter.instance_variable_get(:@export_path), 'csv'))
      exporter.export_categories
      exporter.logger.close
      puts "✓ Exported #{exporter.stats[:categories]} categories"
    end

    desc 'Export forum threads only'
    task threads: :environment do
      puts 'Exporting forum threads...'
      exporter = ForumExporter.new
      exporter.logger.info('Starting threads-only export')
      FileUtils.mkdir_p(File.join(exporter.instance_variable_get(:@export_path), 'csv'))
      exporter.export_threads
      exporter.logger.close
      puts "✓ Exported #{exporter.stats[:threads]} threads"
    end

    desc 'Export forum posts only'
    task posts: :environment do
      puts 'Exporting forum posts...'
      exporter = ForumExporter.new
      exporter.logger.info('Starting posts-only export')
      FileUtils.mkdir_p(File.join(exporter.instance_variable_get(:@export_path), 'csv'))
      exporter.export_posts
      exporter.logger.close
      puts "✓ Exported #{exporter.stats[:posts]} posts"
    end

    desc 'Clean previous export directory'
    task clean: :environment do
      exporter = ForumExporter.new
      exporter.clean!
      exporter.logger.close
      puts '✓ Export directory cleaned'
    end
  end
end
