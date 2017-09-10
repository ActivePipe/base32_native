require "spec_helper"

RSpec.describe Base32Native do
  it "has a version number" do
    expect(Base32Native::VERSION).not_to be nil
  end

  it "encodes and decodes correctly" do
    expect(Base32Native.encode('12345')).to eq 'GEZDGNBV'
    expect(Base32Native.decode('GEZDGNBV')).to eq '12345'

    expect(Base32Native.encode('a')).to eq 'ME'
    expect(Base32Native.decode('ME======')).to eq 'a'

    expect(Base32Native.encode('abcde')).to eq 'MFRGGZDF'
    expect(Base32Native.decode('MFRGGZDF')).to eq 'abcde'
  end

  it "decodes a large string" do
    plaintext = <<-EOT
      We the people of the United States, in order to form a more perfect union,
      establish justice, insure domestic tranquility, provide for the common
      defense, promote the general welfare, and secure the blessings of liberty
      to ourselves and our posterity, do ordain and establish this Constitution
      for the United States of America.
    EOT
    encoded = %W(
      EAQCAIBAEBLWKIDUNBSSA4DFN5YGYZJAN5TCA5DIMUQFK3TJORSWIICTORQXIZLTFQQGS3RA
      N5ZGIZLSEB2G6IDGN5ZG2IDBEBWW64TFEBYGK4TGMVRXIIDVNZUW63RMBIQCAIBAEAQGK43U
      MFRGY2LTNAQGU5LTORUWGZJMEBUW443VOJSSAZDPNVSXG5DJMMQHI4TBNZYXK2LMNF2HSLBA
      OBZG65TJMRSSAZTPOIQHI2DFEBRW63LNN5XAUIBAEAQCAIDEMVTGK3TTMUWCA4DSN5WW65DF
      EB2GQZJAM5SW4ZLSMFWCA53FNRTGC4TFFQQGC3TEEBZWKY3VOJSSA5DIMUQGE3DFONZWS3TH
      OMQG6ZRANRUWEZLSOR4QUIBAEAQCAIDUN4QG65LSONSWY5TFOMQGC3TEEBXXK4RAOBXXG5DF
      OJUXI6JMEBSG6IDPOJSGC2LOEBQW4ZBAMVZXIYLCNRUXG2BAORUGS4ZAINXW443UNF2HK5DJ
      N5XAUIBAEAQCAIDGN5ZCA5DIMUQFK3TJORSWIICTORQXIZLTEBXWMICBNVSXE2LDMEXAU===).join

    expect(Base32Native.decode(encoded)).to eq plaintext
  end

  it "encodes and decodes various lengths correctly" do
    1000.times do |i|
      value = '9' * (i + 1)
      expect(Base32Native.decode(Base32Native.encode(value))).to eq value
    end
  end

  it "decodes existing tokens" do
    encoded = "nqkuorkskfjekuszkrjeifi3bynq6gygdmcbway3ainrkt2pj5hrut2pj5hrut2pj4ne6ty2j5hu6fi3aenrkq27lzcboxsec5bv6uqxkrlfur2wlzifsf2zkznfef6hvcsz5r5iuwpmpkfftykrwfkdl5peif26iqlugx2sc5bv4q23kil4pkfftykrwaa3cvpugq2hbumbqq2sirbrsvcylikrwby3aydrwfihkyavka2vcvva"
    decoded = Base32Native.decode(encoded.upcase)
    puts "Decoded #{decoded.length} bytes"
    puts "Decoded: #{decoded}\n"
    decoded = decoded.bytes.map { |x| x.ord ^ 55 }.pack("c*")
    puts decoded + "\n"
    puts "--"
    expect(true).to eq false

    # l\x15GERQRERYTRD\x15\e\x0E\e\x0F\e\x06\e\x04\e\x03\e\x02\e\x15OOOO\x1AOOOO\x1AOOO\x1AOO\x1AOOO\x15\e\x01\e\x15C_^D\x17^D\x17C_R\x17TVZGV^PY\x17YVZR\x17\xC7\xA8\xA5\x9E\xC7\xA8\xA5\x9E\xC7\xA8\xA5\x9E\x15\e\x15C_^D\x17^D\x17C_R\x17C^C[R\x17\xC7\xA8\xA5\x9E\x15\e\x00\e\x15_CCG\r\x18\x18CRDC\x19TXZ\x15\e\a\e\x06\a\e\x15\aV\x01U\x03U\x15j
  end

=begin
  it "decodes some things" do
    puts "=========="
    puts Base32Native.decode("nqhrwfihkyavka2vcvva")
    puts "=========="

    puts "------------"
    puts Base32Native.decode("nqdbwbq3aunqigyddmbbwai3")
    puts "------------"

    data = [1,1,2,3,4,5,6,7,8,"0a6b4b"]
    packed = data.to_s.bytes.map { |x| x.ord ^ 55 }.pack("c*").to_s

    puts "Encoding packed #{packed.length} bytes:\n"
    puts packed + "\n"
    puts "Result: \n"
    encoded = Base32Native.encode(packed)
    puts "#{encoded}\n"
    puts "--"
    puts "Data:\n#{data.to_s}\n"
    puts "Decoded:\n"
    decoded = Base32Native.decode(encoded).bytes
    puts "Decoded #{decoded.length} bytes"
    puts "#{decoded}\n"
    decoded = decoded.map { |x| x.ord ^ 55 }.pack("c*")
    puts decoded + "\n"
    puts "--"

    # Base32Native.encode(flip_and_pack(data.to_json.bytes)).tr('=', '')

  end

  it "encodes utf8 characters" do
    value = '[1,"property","1",9,8,1,3,4,5,"xxxx-xxxx-xxx-xx-xxx",6,"this is the campaign name 💩💩💩","this is the title 💩",7,"http://test.com",0,10,null,"0a6b4b"]'
    expect(Base32Native.decode(Base32Native.encode(value))).to eq value
  end
=end
end
