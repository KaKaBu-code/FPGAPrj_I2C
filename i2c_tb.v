`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/17 10:27:31
// Design Name: 
// Module Name: i2c_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module i2c_tb(

    );
    
    reg clk_50M;
    reg clk_1M;// ����,���ܴ��ڿ�ʱ�ӵ������
    reg rst_n;
    reg wr_en; // latch
    reg rd_en; // latch
    reg i2c_start; // �����ź� vld��ע���ʱ��Ϊ����
    reg addr_num; // ѡ���źţ����ڵ�ַλ��ѡȡlatch
    reg [15:0] byte_addr; 
    reg [7:0] wr_data;
    wire i2c_sda_w;
    wire sda_en_master;
    // ʱ������
    initial begin
        clk_50M = 1'b1;
        forever #10 clk_50M = ~clk_50M;
    end
    initial begin
        clk_1M = 1'b1;
        forever #500 clk_1M = ~clk_1M;
    end
    // ��ʼ��
    initial begin
        rst_n = 1'b0;
        wr_en = 1'b0;
        rd_en = 1'b0;
        i2c_start = 1'b0;
        addr_num = 1'b0;
        byte_addr = 'd0;
        wr_data = 'd0;
        #2000;
        rst_n = 1'b1;
    end
    // α�ӻ�Ӧ��,������ʹ���ź����ͺ󣬴ӻ���������
    assign i2c_sda_w = (!sda_en_master) ? 1'b0 : 1'bz;
    /*---------------------------------------
    �������ѡ�񳡾���
    1�����ֽ�д�������洢��ַΪ���ֽ�ģʽ
    ----------------------------------------*/
    // ���ֽ�д�������洢��ַΪ���ֽ�ģʽ
    initial begin
        #2001; // �ȴ���λ����
        wr_en = 1'b1;
        byte_addr = 16'h00_55;
        wr_data = 8'h89;
        @(negedge clk_1M); // ע��i2c_clk��ֵΪ1�˴���ʱ
        @(negedge clk_1M); // �½���������֤��������ȷ����
        i2c_start = 1'b1;   // ��������
        @(negedge clk_1M);
        i2c_start = 1'b0;
    end
    

i2c_ctrl U_i2c_ctrl

(
    .sys_clk(clk_50M),   //����ϵͳʱ�ӣ�Ƶ��Ϊ50MHz
    .sys_rst_n(rst_n),   //���븴λ�źţ��͵�ƽ��Ч
    .wr_en(wr_en),      //����дʹ���ź�
    .rd_en(rd_en),      //�����ʹ���ź�
    .i2c_start(i2c_start),   //����i2c�����ź�
    .addr_num(addr_num),     //����i2c�ֽڵ�ַ�ֽ���
    .byte_addr(byte_addr),   //����i2c�ֽڵ�ַ
    .wr_data(wr_data),      //����i2c�豸����
    .sda_en(sda_en_master),
//    output  reg             i2c_clk     ,   //i2c����ʱ��
//    output  reg             i2c_end     ,   //i2cһ�ζ�/д�������
//    output  reg     [7:0]   rd_data     ,   //���i2c�豸��ȡ����
//    output  reg             i2c_scl     ,   //�����i2c�豸�Ĵ���ʱ���ź�scl
    .i2c_sda(i2c_sda_w)         //�����i2c�豸�Ĵ��������ź�sda
);
    
endmodule
