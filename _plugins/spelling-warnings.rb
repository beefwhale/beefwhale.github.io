# frozen_string_literal: true

require "open3"

Jekyll::Hooks.register :site, :post_read do |site|
  next if site.config["serving"]

  cspell = File.join(site.source, "node_modules", ".bin", "cspell")

  unless File.executable?(cspell)
    Jekyll.logger.warn "Spell check:", "CSpell is unavailable; run `npm install` to enable spelling warnings."
    next
  end

  output, status = Open3.capture2e(
    cspell,
    "lint",
    "--config",
    File.join(site.source, "cspell.json"),
    "--no-progress",
    "--report",
    "typos",
    chdir: site.source
  )

  next if status.success?

  output.each_line do |line|
    line = line.strip
    Jekyll.logger.warn "Spelling:", line unless line.empty?
  end
end
