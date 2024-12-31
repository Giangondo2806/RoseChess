
// Assets paths
const String boardAsset = 'assets/images/xiangqiboards/simple.svg';
const String RR = 'assets/images/xiangqipieces/wikipedia/rr.svg';
const String RN = 'assets/images/xiangqipieces/wikipedia/rn.svg';
const String RB = 'assets/images/xiangqipieces/wikipedia/rb.svg';
const String RA = 'assets/images/xiangqipieces/wikipedia/ra.svg';
const String RK = 'assets/images/xiangqipieces/wikipedia/rk.svg';
const String RC = 'assets/images/xiangqipieces/wikipedia/rc.svg';
const String RP = 'assets/images/xiangqipieces/wikipedia/rp.svg';
const String BR = 'assets/images/xiangqipieces/wikipedia/br.svg';
const String BN = 'assets/images/xiangqipieces/wikipedia/bn.svg';
const String BB = 'assets/images/xiangqipieces/wikipedia/bb.svg';
const String BA = 'assets/images/xiangqipieces/wikipedia/ba.svg';
const String BK = 'assets/images/xiangqipieces/wikipedia/bk.svg';
const String BC = 'assets/images/xiangqipieces/wikipedia/bc.svg';
const String BP = 'assets/images/xiangqipieces/wikipedia/bp.svg';

// Mapping of notations to hexadecimal values (SQUARES)
const Map<String, int> SQUARES = {
  'a9': 0x00,
  'b9': 0x01,
  'c9': 0x02,
  'd9': 0x03,
  'e9': 0x04,
  'f9': 0x05,
  'g9': 0x06,
  'h9': 0x07,
  'i9': 0x08,
  'a8': 0x10,
  'b8': 0x11,
  'c8': 0x12,
  'd8': 0x13,
  'e8': 0x14,
  'f8': 0x15,
  'g8': 0x16,
  'h8': 0x17,
  'i8': 0x18,
  'a7': 0x20,
  'b7': 0x21,
  'c7': 0x22,
  'd7': 0x23,
  'e7': 0x24,
  'f7': 0x25,
  'g7': 0x26,
  'h7': 0x27,
  'i7': 0x28,
  'a6': 0x30,
  'b6': 0x31,
  'c6': 0x32,
  'd6': 0x33,
  'e6': 0x34,
  'f6': 0x35,
  'g6': 0x36,
  'h6': 0x37,
  'i6': 0x38,
  'a5': 0x40,
  'b5': 0x41,
  'c5': 0x42,
  'd5': 0x43,
  'e5': 0x44,
  'f5': 0x45,
  'g5': 0x46,
  'h5': 0x47,
  'i5': 0x48,
  'a4': 0x50,
  'b4': 0x51,
  'c4': 0x52,
  'd4': 0x53,
  'e4': 0x54,
  'f4': 0x55,
  'g4': 0x56,
  'h4': 0x57,
  'i4': 0x58,
  'a3': 0x60,
  'b3': 0x61,
  'c3': 0x62,
  'd3': 0x63,
  'e3': 0x64,
  'f3': 0x65,
  'g3': 0x66,
  'h3': 0x67,
  'i3': 0x68,
  'a2': 0x70,
  'b2': 0x71,
  'c2': 0x72,
  'd2': 0x73,
  'e2': 0x74,
  'f2': 0x75,
  'g2': 0x76,
  'h2': 0x77,
  'i2': 0x78,
  'a1': 0x80,
  'b1': 0x81,
  'c1': 0x82,
  'd1': 0x83,
  'e1': 0x84,
  'f1': 0x85,
  'g1': 0x86,
  'h1': 0x87,
  'i1': 0x88,
  'a0': 0x90,
  'b0': 0x91,
  'c0': 0x92,
  'd0': 0x93,
  'e0': 0x94,
  'f0': 0x95,
  'g0': 0x96,
  'h0': 0x97,
  'i0': 0x98,
};

// Initial board setup as a 2D array

const MAX_ROWS = 10;
const MAX_COLS = 9;