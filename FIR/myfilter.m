function out = myfilter(b,a,in) % 輸出=函式名稱(輸入,輸入,輸入)

Buffer = zeros(length(b),1); %改良版後只剩一組暫存器
out = zeros(length(in),1); %先宣告零矩陣

for i = 1:length(in) %用for迴圈處理所有訊號
    Buffer(1) = in(i); %把輸入音訊訊號,依次讀入
    for j = 1:length(b) %先算FIR
        out(i) = out(i) + b(j)*Buffer(j);
    end
    
    for j = 2;length(a) %再算IIR
        if i <= length(b) %為了避免抓到矩陣位址0
            out(i) = out(i) - a(j)*out(i-j+1+(length(b)-i));      
        else
            out(i) = out(i) - a(j)*out(i-j+1);
        end
    end
    
    for j = length(b):-1:2
        Buffer(j) = Buffer(j-1); %把矩陣做位移
    end
end