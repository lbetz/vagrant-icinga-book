Puppet::Parser::Functions.newfunction(
  :randstr,
  :type => :rvalue,
  :doc => 'Generates a random string of readable characters of length n'
) do |args|
  size = args[0] ? args[0].to_i : 6

  # omit characters that are easily misread
  charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z a b c d e f g h k m n p q r s t w x y z}
  (0...size).map{ charset.to_a[rand(charset.size)] }.join
end
