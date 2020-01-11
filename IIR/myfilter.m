function out = myfilter(b,a,in) 

BufferII  = zeros(length(b),1);
out = zeros(length(in),1);

for i=1:length(in)
      BufferII(1) = in(i);

      for j=1:length(b)
         out(i) = out(i) + b(j) * BufferII(j);
      end

      for j=2:length(a)
            if(i<=length(b))
                out(i) = out(i) - a(j) * out(i - j + 1 + (length(b) - i));
            else  
                out(i) = out(i) - a(j) * out(i - j + 1);
            end
      end

      for j=length(b):-1:2
          BufferII(j) = BufferII(j-1);
      end
end