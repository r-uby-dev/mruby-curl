load File.join(__dir__, "mrblib", "curl", "version.rb")

MRuby::Gem::Specification.new('mruby-curl') do |spec|
  spec.license = 'MIT'
  spec.authors = 'mattn'
  spec.version = Curl::VERSION

  spec.linker.libraries << 'curl'
  spec.add_dependency 'mruby-http'

  if ENV["ENV"] == "TEST"
    spec.add_dependency 'mruby-minitest', github: '0x1eef/mruby-minitest', branch: "main"
  end
end
