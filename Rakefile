require 'rake'
require 'rake/rdoctask'

desc 'Generate documentation for the exception notifier plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Exception Notifier'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('app/**/*.rb')
end
