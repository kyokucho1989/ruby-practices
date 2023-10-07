# frozen_string_literal: true

class LsFile
  attr_reader :name, :file_stat

  def initialize(name, option)
    @name = name
    return unless option.l_option

    @file_stat = FileTest.symlink?(name) ? File.lstat(name) : File.stat(name)
  end

  def readlink
    FileTest.symlink?(@name) ? " -> #{File.readlink(@name)}" : ''
  end

  def permission
    permission_numbers = @file_stat.mode.to_s(8)
    cut_numbers = permission_numbers[-3, 3].chars
    permission_chars = ''
    permission_chars += cut_numbers.map do |n|
      (0..2).map { |i| (n.to_i & 0b100 >> i).zero? ? '-' : 'rwx'[i] }.join
    end.join
    permission_chars
  end

  def mode
    type = @file_stat.ftype
    if type == 'directory'
      'd'
    elsif type == 'link'
      'l'
    else
      '-'
    end
  end

  def hardlink
    @file_stat.nlink.to_s
  end

  def owner
    Etc.getpwuid(@file_stat.uid).name
  end

  def group
    Etc.getgrgid(@file_stat.gid).name
  end

  def size
    @file_stat.size.to_s
  end

  def timestamp
    date = @file_stat.ctime
    date_arg = Date.today.year == date.year ? '%_m %_d %R' : '%_m %_d  %Y'
    date.strftime(date_arg)
  end
end
