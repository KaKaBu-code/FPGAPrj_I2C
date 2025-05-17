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
    reg clk_1M;// 慢钟,可能存在跨时钟的情况。
    reg rst_n;
    reg wr_en; // latch
    reg rd_en; // latch
    reg i2c_start; // 脉冲信号 vld，注意该时钟为慢钟
    reg addr_num; // 选择信号，用于地址位宽选取latch
    reg [15:0] byte_addr; 
    reg [7:0] wr_data;
    wire i2c_sda_w;
    wire sda_en_master;
    // 时钟生成
    initial begin
        clk_50M = 1'b1;
        forever #10 clk_50M = ~clk_50M;
    end
    initial begin
        clk_1M = 1'b1;
        forever #500 clk_1M = ~clk_1M;
    end
    // 初始化
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
    // 伪从机应答,当主机使能信号拉低后，从机发送数据
    assign i2c_sda_w = (!sda_en_master) ? 1'b0 : 1'bz;
    /*---------------------------------------
    依据情况选择场景：
    1、单字节写操作，存储地址为单字节模式
    ----------------------------------------*/
    // 单字节写操作，存储地址为单字节模式
    initial begin
        #2001; // 等待复位结束
        wr_en = 1'b1;
        byte_addr = 16'h00_55;
        wr_data = 8'h89;
        @(negedge clk_1M); // 注因i2c_clk初值为1此次延时
        @(negedge clk_1M); // 下降沿置数保证上升沿正确接收
        i2c_start = 1'b1;   // 脉冲生成
        @(negedge clk_1M);
        i2c_start = 1'b0;
    end
    

i2c_ctrl U_i2c_ctrl

(
    .sys_clk(clk_50M),   //输入系统时钟，频率为50MHz
    .sys_rst_n(rst_n),   //输入复位信号，低电平有效
    .wr_en(wr_en),      //输入写使能信号
    .rd_en(rd_en),      //输入读使能信号
    .i2c_start(i2c_start),   //输入i2c触发信号
    .addr_num(addr_num),     //输入i2c字节地址字节数
    .byte_addr(byte_addr),   //输入i2c字节地址
    .wr_data(wr_data),      //输入i2c设备数据
    .sda_en(sda_en_master),
//    output  reg             i2c_clk     ,   //i2c驱动时钟
//    output  reg             i2c_end     ,   //i2c一次读/写操作完成
//    output  reg     [7:0]   rd_data     ,   //输出i2c设备读取数据
//    output  reg             i2c_scl     ,   //输出至i2c设备的串行时钟信号scl
    .i2c_sda(i2c_sda_w)         //输出至i2c设备的串行数据信号sda
);
    
endmodule
