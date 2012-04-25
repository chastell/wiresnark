require 'rake/testtask'

task default: :spec

desc 'Compile the regset library'
task :build_regset do
  system 'gcc -c -fPIC -o ext/wiresnark/regset.o ext/wiresnark/regset.c'
  system 'gcc -shared -o ext/wiresnark/regset.so ext/wiresnark/regset.o'
end

Rake::TestTask.new :spec do |task|
  task.test_files = FileList['spec/**/*_spec.rb']
  task.warning    = true
end
