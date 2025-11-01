require 'bundler/setup'
Bundler.require(:default)

$ROOT = Pathname.new(__dir__ + '/..')

loader = Zeitwerk::Loader.new
loader.push_dir($ROOT.join('lib').to_s)
loader.inflector.inflect(
  'db' => 'DB',
  'wal' => 'WAL',
  'sstable' => 'SSTable'
)
loader.setup
loader.eager_load
