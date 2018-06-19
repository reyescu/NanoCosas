
x=ax{3}.array;
datfit=Dat1GN;
siz=size(ch{1}.s1);
ax{2}=ax{1};
ch{2}=ch{1};

for i=1:siz(1)
    for j=1:siz(2)
    y=gass1f(x,squeeze(datfit(i,j,:)));
    ch{2}.s1(i,j,:)=y;
    end
end