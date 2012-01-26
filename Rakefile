require 'rubygems'
require 'rake'
require 'spec/rake/spectask'
require 'rcov'
require 'rcov/rcovtask'

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |t|
  t.spec_files = FileList["spec/*_spec.rb"]
  t.rcov = true
end

task :default  => :spec
