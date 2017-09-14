require "spec_helper"

RSpec.describe Base32Native do
  it 'has a version number' do
    expect(Base32Native::VERSION).not_to be nil
  end

  it 'encodes and decodes correctly' do
    expect(Base32Native.encode('12345')).to eq 'GEZDGNBV'
    expect(Base32Native.decode('GEZDGNBV')).to eq '12345'

    expect(Base32Native.encode('a')).to eq 'ME'
    expect(Base32Native.decode('ME======')).to eq 'a'

    expect(Base32Native.encode('abcde')).to eq 'MFRGGZDF'
    expect(Base32Native.decode('MFRGGZDF')).to eq 'abcde'
  end

  it 'decodes a large string' do
    plaintext = <<-EOT
      We the people of the United States, in order to form a more perfect union,
      establish justice, insure domestic tranquility, provide for the common
      defense, promote the general welfare, and secure the blessings of liberty
      to ourselves and our posterity, do ordain and establish this Constitution
      for the United States of America.
    EOT
    encoded = %w[
      EAQCAIBAEBLWKIDUNBSSA4DFN5YGYZJAN5TCA5DIMUQFK3TJORSWIICTORQXIZLTFQQGS3RA
      N5ZGIZLSEB2G6IDGN5ZG2IDBEBWW64TFEBYGK4TGMVRXIIDVNZUW63RMBIQCAIBAEAQGK43U
      MFRGY2LTNAQGU5LTORUWGZJMEBUW443VOJSSAZDPNVSXG5DJMMQHI4TBNZYXK2LMNF2HSLBA
      OBZG65TJMRSSAZTPOIQHI2DFEBRW63LNN5XAUIBAEAQCAIDEMVTGK3TTMUWCA4DSN5WW65DF
      EB2GQZJAM5SW4ZLSMFWCA53FNRTGC4TFFQQGC3TEEBZWKY3VOJSSA5DIMUQGE3DFONZWS3TH
      OMQG6ZRANRUWEZLSOR4QUIBAEAQCAIDUN4QG65LSONSWY5TFOMQGC3TEEBXXK4RAOBXXG5DF
      OJUXI6JMEBSG6IDPOJSGC2LOEBQW4ZBAMVZXIYLCNRUXG2BAORUGS4ZAINXW443UNF2HK5DJ
      N5XAUIBAEAQCAIDGN5ZCA5DIMUQFK3TJORSWIICTORQXIZLTEBXWMICBNVSXE2LDMEXAU===
    ].join

    expect(Base32Native.decode(encoded)).to eq plaintext
  end

  it 'encodes and decodes various lengths correctly' do
    1000.times do |i|
      value = '9' * (i + 1)
      expect(Base32Native.decode(Base32Native.encode(value))).to eq value
    end
  end

  it 'encodes various bytes' do
    value = '[1,1,2,3,4,5,6,7,8,"0a6b4b"]'
    value_bytes = value.bytes.map { |x| x.ord ^ 55 }.pack('c*')
    encoded = Base32Native.encode(value_bytes)
    decoded_bytes = Base32Native.decode(encoded)
    decoded = decoded_bytes.bytes.map { |x| x.ord ^ 55 }.pack('c*')
    expect(encoded).to eq 'NQDBWBQ3AUNQIGYDDMBBWAI3AANQ6GYVA5LACVIDKUKWU'
    expect(decoded).to eq value
  end
end
