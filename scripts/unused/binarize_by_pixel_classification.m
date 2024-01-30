clear;
close all;

bg   = im2double(imread('./dataset/binarize/bg.png'));
[rs,cs,ch] = size(bg);
bg = reshape(bg,rs*cs,ch);

fg = im2double(imread('./dataset/binarize/fg.png'));
[rns,cns,ch] = size(fg);
fg = reshape(fg,rns*cns,ch);

train.values = [fg;bg];
train.labels = uint8([ones(rns*cns,1);zeros(rs*cs,1)]);
%train.labels = uint8([zeros(1000,1);ones(1000,1)]);

C = fitcknn(train.values,train.labels,'NumNeighbors',10);

image = im2double(imread('./dataset/uno-test-02.jpg'));
[ri,ci,ch] = size(image);
test.values = reshape(image,ri*ci,ch);

predicted = predict(C,test.values);

p = reshape(predicted,ri,ci,1)>0;
show_result(image,p);
