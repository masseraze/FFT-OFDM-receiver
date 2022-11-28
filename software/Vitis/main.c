#include <stdio.h>
#include "xil_io.h"
#include "xparameters.h"
//include "data_SNR_1.h"
#include "file_1.h"
#define in_data  20000
#define get_data 1000
u32 i,j,k,l,m,n,sw,temp,err_n,total;
u16 output;
u16 Err_BitCnt[get_data];

const u8 BitCount_Tab[16] = {0, 1, 1, 2, 1, 2, 2, 3,
							 1, 2, 2, 3, 2, 3, 3, 4};

void give_data(int num,u32 en);
void print_d(int o);
void mask();

int main(){
	// reset
	sw=1,err_n=0,total=0;
	Xil_Out32(XPAR_AXI_GPIO_0_BASEADDR, 1);
	Xil_Out32(XPAR_AXI_GPIO_0_BASEADDR, 0);
	Xil_Out32(XPAR_AXI_GPIO_1_BASEADDR, 0);
	//give data
	for(int r=0; r<in_data; r=r+1){
		give_data(r,sw%2);
		sw++;
		if((r%20)==19){ //when input 20 of data, ex. 0~19, 20~39, 40~59
			print_d(r); //print output
			mask(); //compare hardware demod data with software demod data difference
		}
	}
	printf("\n ---summary---\n");
	for(int r=0; r<get_data; r=r+1){
		if(Err_BitCnt[r]!=0){
			printf("Err_BitCnt[%d] : %d\n",r,Err_BitCnt[r]);
			total++;
		}
	}
	printf("%d of demod data error bit=0\n",get_data-total);

	return 0;
}
void give_data(int num,u32 en){
	Xil_Out32(XPAR_AXI_GPIO_2_BASEADDR, fft_real[num]);//real
	Xil_Out32(XPAR_AXI_GPIO_3_BASEADDR, fft_imag[num]);//imag
	Xil_Out32(XPAR_AXI_GPIO_1_BASEADDR, en);//en

	//print_d(num);
}

void print_d(int o){
	/* debugger
	i=Xil_In32(XPAR_AXI_GPIO_5_BASEADDR);
	j=Xil_In32(XPAR_AXI_GPIO_6_BASEADDR);
	k=Xil_In32(XPAR_AXI_GPIO_7_BASEADDR);
	l=Xil_In32(XPAR_AXI_GPIO_8_BASEADDR);
	m=Xil_In32(XPAR_AXI_GPIO_9_BASEADDR);
	n=Xil_In32(XPAR_AXI_GPIO_10_BASEADDR);
	*/
	output = Xil_In32(XPAR_AXI_GPIO_4_BASEADDR);
	printf("\n------------------\n");
	printf("The %d time\n",o+1);
	/* debugger
	printf("s_p dout0 data: %x\n",i);
	printf("s_p dout1 data: %x\n",j);
	printf("fft dout0 data: %x\n",k);
	printf("fft dout1 data: %x\n",l);
	printf("equalizer dout0,dout1: %x\n",m);
	printf("en_flag,counter: %x\n",n);
	*/
	printf("------------------\n");
	printf("output: %x, ", output);

	//i=0,j=0,k=0,l=0,m=0,n=0;
}

void mask(){
	temp=0;
	temp=output^pre_ans[err_n];//0101101110011011
	printf("pre ans :%x\n",pre_ans[err_n]);
	//printf("compare differ:%x\n",temp);
	Err_BitCnt[err_n] += (BitCount_Tab[temp>>12] + BitCount_Tab[(temp & 0x0F00)>>8] +
				   BitCount_Tab[(temp & 0x00F0)>>4] + BitCount_Tab[temp & 0x000F]);
	//printf("error number: %d\n",Err_BitCnt[err_n]);
	err_n++;
}

