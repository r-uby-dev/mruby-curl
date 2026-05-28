MRuby::Gem::Specification.new('mruby-curl') do |spec|
  spec.license = 'MIT'
  spec.authors = 'mattn'
  spec.version = "0.1.2"

  spec.linker.libraries << 'curl'
  spec.add_dependency 'mruby-http'
  spec.rbfiles.concat Dir[
    File.expand_path("mrblib/*.rb", __dir__),
    File.expand_path("mrblib/**/*.rb", __dir__)
  ]

  if ENV["ENV"] == "TEST"
    spec.add_dependency 'mruby-minitest', github: '0x1eef/mruby-minitest', branch: "main"
  end
end
