function out = myfilter(b,a,in) % ��X=�禡�W��(��J,��J,��J)

Buffer = zeros(length(b),1); %��}����u�Ѥ@�ռȦs��
out = zeros(length(in),1); %���ŧi�s�x�}

for i = 1:length(in) %��for�j��B�z�Ҧ��T��
    Buffer(1) = in(i); %���J���T�T��,�̦�Ū�J
    for j = 1:length(b) %����FIR
        out(i) = out(i) + b(j)*Buffer(j);
    end
    
    for j = 2;length(a) %�A��IIR
        if i <= length(b) %���F�קK���x�}��}0
            out(i) = out(i) - a(j)*out(i-j+1+(length(b)-i));      
        else
            out(i) = out(i) - a(j)*out(i-j+1);
        end
    end
    
    for j = length(b):-1:2
        Buffer(j) = Buffer(j-1); %��x�}���첾
    end
end