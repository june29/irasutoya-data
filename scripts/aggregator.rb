require 'yaml'
require 'json'

data = Dir.glob('data/*.yml').map { |path|
  YAML.load_file(path)
}

File.write('dist/irasutoya.json', JSON.dump(data))
