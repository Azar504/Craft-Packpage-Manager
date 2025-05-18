#!/usr/bin/env ruby
require 'open3'
require 'fileutils'
require 'json'

LOG_FILE = './logs/actions.log'
INSTALL_DIR = '/data/data/com.termux/files/opt'
SHIMS_DIR = '/data/data/com.termux/files/usr/bin'

def log(msg)
  File.open(LOG_FILE, 'a') { |f| f.puts("#{Time.now} | #{msg}") }
  puts "[✓] #{msg}" if ENV['CRAFT_DEBUG']
end

def error(msg)
  File.open(LOG_FILE, 'a') { |f| f.puts("#{Time.now} | ERROR: #{msg}") }
  warn "[×] #{msg}"
end

def system_call(cmd)
  log("Executando: #{cmd}")
  stdout, stderr, status = Open3.capture3(cmd)
  raise stderr unless status.success?
  stdout.strip
end

def detect_arch
  arch = system_call('uname -m')
  return 'arm64' if arch =~ /aarch64/
  return 'armv7' if arch =~ /armv7/
  'unknown'
end

def detect_install_method(pkg)
  return :binary_release if %w[zig nmap sqlmap].include?(pkg)
  return :source_code if %w[redis postgresql].include?(pkg)
  :termux_pkg
end

def install_via_termux(pkg)
  log("Instalando via pkg: #{pkg}")
  system_call("pkg install -y #{pkg}")
end

def install_via_binary(pkg)
  arch = detect_arch
  url = "https://example.com/#{pkg}-latest-#{arch}.tar.gz"
  tmp_dir = "/tmp/craft_#{pkg}"
  FileUtils.mkdir_p(tmp_dir)
  system_call("curl -fSL #{url} -o #{tmp_dir}/#{pkg}.tar.gz")
  system_call("tar -xf #{tmp_dir}/#{pkg}.tar.gz -C #{tmp_dir}")
  target_dir = "#{INSTALL_DIR}/#{pkg}"
  FileUtils.rm_rf(target_dir)
  FileUtils.mv("#{tmp_dir}/#{pkg}", target_dir)
  Dir.glob("#{target_dir}/bin/*").each do |bin|
    FileUtils.ln_sf(bin, "#{SHIMS_DIR}/#{File.basename(bin)}")
  end
  FileUtils.rm_rf(tmp_dir)
  log("Pacote #{pkg} instalado via binário")
end

def install_via_source(pkg)
  error("Compilação de #{pkg} não implementada")
  raise "Fonte não suportada"
end

def attempt_fallback(pkg)
  error("Fallback não implementado para #{pkg}")
  false
end

def install(pkg)
  method = detect_install_method(pkg)
  begin
    case method
    when :termux_pkg then install_via_termux(pkg)
    when :binary_release then install_via_binary(pkg)
    when :source_code then install_via_source(pkg)
    else raise "Método desconhecido para #{pkg}"
    end
  rescue => e
    error("Falha ao instalar #{pkg}: #{e}")
    attempt_fallback(pkg)
  end
end

def update_self
  error("Autoatualização não implementada")
end

def audit
  installed = Dir.children(INSTALL_DIR).select { |d| File.directory?("#{INSTALL_DIR}/#{d}") }
  puts JSON.pretty_generate({ installed_packages: installed })
end

def rollback(pkg)
  target_dir = "#{INSTALL_DIR}/#{pkg}"
  if Dir.exist?(target_dir)
    FileUtils.rm_rf(target_dir)
    log("Rollback de #{pkg} concluído")
  else
    error("Pacote #{pkg} não instalado")
  end
end

def plugin(args)
  action = args.first
  case action
  when 'list'
    plugins = Dir.children('/var/lib/craft/plugins')
    puts plugins.join("\n")
  else
    error("Ação de plugin desconhecida")
  end
end

command = ARGV.shift
case command
when 'install' then install(ARGV.shift)
when 'update_self' then update_self
when 'audit' then audit
when 'rollback' then rollback(ARGV.shift)
when 'plugin' then plugin(ARGV)
else
  error("Comando desconhecido")
  exit 1
end
