
Artist = "Skeler"
Album  = "N i g h t D r i v e スケラー"
Track  = "ID"

Years = {
  "I"   => "2020",
  "II"  => "2021",
  "III" => "2023",
  "IV"  => "2024",
}

TS_RX = /(\d+):(\d+):(\d+)/
TI_RX = /\d+:\d+:\d+ (.+)/

@files = Dir.glob("I*.txt")
@files.each do |file|
  edition = file.split(".")[0]
  year    = Years[edition]
  ofile   = "01 - #{Album} #{edition} Mix.cue"
  data    = File.read(file).split("\n")
  File.open(ofile, "w") do |f|
    f.puts "PERFORMER \"#{Artist}\""
    f.puts "REM DATE  \"#{year}\""
    f.puts "TITLE \"#{Album} #{edition}\""
    f.puts "REM GENRE \"Phonk/Wave\""
    f.puts "FILE \"01 - #{Album} #{edition} Mix.mp3\" MP3"
    count = 1
    data.each do |line|
      time = line.match(TS_RX)
      t1 = time[1].to_i
      t2 = time[2].to_i
      t3 = time[3].to_i
      t2 += t1 * 60
      title = line.match(TI_RX)[1].strip rescue Track
      title.gsub!(/#{Artist} - /, '')
      title = "#{Track} => #{title}" unless title == Track
      title += " (#{Artist} Remix)" if title.include?(' - ') unless title.include?(Artist)
      f.puts "  TRACK #{count.to_s.rjust(2, '0')} AUDIO"
      f.puts "    TITLE \"#{title}\""
      f.puts "    INDEX 01 #{t2.to_s.rjust(2, '0')}:#{t3.to_s.rjust(2, '0')}:00"
      count += 1
    end
  end
end
