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
end
