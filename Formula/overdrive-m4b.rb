class OverdriveM4b < Formula
  desc "A dirty script to convert Overdrive audiobooks to a single m4b file"
  homepage "https://github.com/pflouret/overdrive-m4b"
  head "https://github.com/pflouret/overdrive-m4b.git"
  url "https://github.com/pflouret/overdrive-m4b/archive/1.0.0.tar.gz"
  sha256 "259c688d7f6fb5683838c91b3e4f42ccc3b0bbfb1000dfdf62225f0fbcae0ba2"

  uses_from_macos "ruby"

  option "without-fdk-aac", "Use the official brew ffmpeg instead of one compiled with libfdk_aac"

  depends_on "mp4v2"
  if build.without? "fdk-aac"
    depends_on "ffmpeg"
  else
    depends_on "homebrew-ffmpeg/ffmpeg/ffmpeg" => ["with-fdk-aac"]
  end

  resource "nokogiri" do
    url "https://rubygems.org/downloads/nokogiri-1.10.7.gem"
    sha256 "96ce81f44eb9b47494d09b6e74f5eae00bbdf01b267b73c224e64080dcbb1864"
  end

  resource "id3tag" do
    url "https://rubygems.org/downloads/id3tag-0.12.1.gem"
    sha256 "924b19e06810e3bfad6cc2596ff487abce896639a7fba18eb59594caba72c23b"
  end


  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    system "gem", "build", "overdrive-m4b.gemspec"
    system "gem", "install", "--ignore-dependencies", "overdrive-m4b-#{version}.gem"
    bin.install libexec/"bin/overdrive-m4b"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    assert_match version, shell_output("#{bin}/overdrive-m4b --version")
  end
end
