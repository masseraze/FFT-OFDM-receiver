
#include<stdio.h>
static u16 fft_real[]={
	0xFF0E,0xFFD3,0xFF95,0x005F,0xFF5C,0xFFA4,0xFF95,0x004F,0xFF08,0xFF69,0xFF85,0xFF84,0xFF28,0xFED3,0xFFC0,0xFFEF,0xFEE4,0xFFB2,0xFFA1,0xFFDA,
	0x0083,0x0120,0x00AD,0x00D1,0xFF7D,0xFFF6,0x000C,0x0065,0x00BA,0x00D4,0x0137,0x00B8,0xFF1E,0xFF95,0x009E,0x0061,0x0031,0x011F,0x0060,0x00AB,
	0x0121,0xFFEB,0x00BD,0x007F,0x00E9,0x00A0,0x0120,0xFFE1,0x001A,0xFFEB,0xFFA8,0x007F,0x00AD,0x015D,0x0075,0xFFD9,0x0040,0xFF7B,0x0003,0x0060,
	0xFFB9,0xFF93,0xFF5C,0xFF29,0xFEF5,0xFEA3,0xFED6,0xFEFE,0xFEDD,0xFF74,0xFFB7,0x00C3,0xFF95,0x008B,0x0041,0x0030,0xFF4A,0xFF8B,0xFF86,0xFEAC,
	0x0048,0x0025,0xFF84,0xFF34,0xFFD3,0xFFBB,0xFF07,0xFED1,0x0057,0x00A7,0xFFA8,0x0039,0xFE2E,0xFF0A,0xFEEA,0xFFCA,0x0034,0x0103,0xFF97,0xFF28,
	0xFFB8,0x016D,0x0124,0x00C4,0xFF6B,0xFF44,0x001F,0x016E,0x0118,0x000C,0x00EF,0x001A,0x0000,0xFFDA,0x009B,0xFFFB,0x0067,0x018F,0x01AF,0x0078,
	0xFFB3,0xFF1F,0xFFD2,0x002D,0x0099,0x00C5,0x012A,0xFF99,0xFF01,0xFEAF,0xFF3C,0xFDA5,0x0003,0xFEF2,0xFF5F,0xFEFC,0xFF24,0xFEBC,0xFFE9,0x0085,
	0xFFC7,0x003A,0x002B,0xFFFC,0xFFE2,0x0004,0xFF9F,0x00BE,0xFFEC,0xFF9C,0xFFDB,0x01B9,0x019C,0x026E,0x01B7,0x00F7,0xFFAA,0x007F,0x003D,0x001C
	,0x005C,0xFFFF,0xFF65,0xFF26,0x0155,0x0005,0xFF81,0xFF1F,0xFF44,0xFEA9,0xFEEB,0xFFA4,0x000C,0x003F,0xFFB7,0xFF0E,0xFF81,0xFF53,0xFF70,0xFF17
	,0xFF2D,0xFF1B,0xFE0D,0xFEB6,0xFFEC,0x0008,0xFE47,0xFE52,0xFE95,0xFF1A,0xFF96,0x0093,0x0042,0x010A,0x006D,0xFFEE,0xFFAD,0xFF94,0xFDAD,0xFEA8
	,0x0012,0xFF11,0x0006,0xFFA4,0xFDD9,0xFDD7,0xFF44,0xFEA1,0x0033,0xFF91,0xFEEE,0x000B,0x0071,0x0111,0xFFF1,0xFFE0,0x003F,0xFECB,0x0065,0xFF21
};
static u16 fft_imag[]={
	0xFF6B,0xFF9D,0x001F,0xFFFC,0xFFF1,0x0005,0x0017,0xFFA7,0x006F,0xFF9C,0xFEC0,0xFE42,0xFF7B,0xFFDB,0x01C5,0x01A4,0x0085,0x003B,0x0053,0x004D,
	0x005F,0x005C,0x00D9,0x0115,0x009C,0xFFD7,0xFF80,0xFF5E,0xFF6D,0xFFCB,0xFF21,0xFEBB,0xFF55,0x008D,0x00CA,0x010F,0x002D,0x005E,0x008D,0x00AD,
	0xFF76,0xFED9,0xFF68,0x0001,0xFFA5,0x0022,0xFFA1,0x0093,0x0149,0x00FA,0x0052,0x0075,0x0034,0xFFC6,0xFFC6,0x001A,0xFE9D,0xFE6B,0xFF3A,0x0002,
	0xFF36,0xFF0D,0xFFE4,0xFFB6,0xFFE8,0xFFD0,0xFF71,0x0094,0x00AB,0x001A,0xFFD0,0xFF19,0xFF8E,0x0023,0x00B2,0x00ED,0xFFF4,0xFF7F,0xFF9A,0xFF88,
	0x0043,0x008F,0x0089,0x00A0,0x0015,0xFFF2,0xFFEE,0xFF69,0xFF33,0xFF0E,0xFF2C,0xFFCB,0xFF89,0xFFEC,0x00AC,0x0054,0x008A,0x005D,0x00A9,0x00B1,
	0x00AF,0x0136,0x0080,0x007B,0x0066,0xFF9B,0xFF97,0xFF2A,0xFF66,0xFEFE,0xFF39,0xFFC0,0xFFDF,0xFFF5,0x006E,0x0086,0x00C1,0x012B,0x008E,0x005F
	,0x00E4
};
static u16 pre_ans[] = {
	0b0101101110011011,0b0101011111011110,0b1000110001011000,0b1101010100011011,0b0100010101000111,0b0111001011011110
};