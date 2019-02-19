module FileSpecHelper
  class << self
    def csv
      csv_create
      File.open(Dir[path_to('csv')].sample)
    end

    private

    def path_to(folder)
      Rails.root.join('spec', 'samples', folder, '*')
    end

    def csv_create
      path = Rails.root.join('spec', 'samples', 'csv', 'file.csv')
      csv = Faker::CSV.participants

      File.write(path, csv)
    end
  end
end
