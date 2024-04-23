clc;
clear all;

left = readraw('left.raw', 432, 576, false);
mid = readraw('middle.raw', 432, 576, false);
right = readraw('right.raw', 432, 576, false);

gray_left = rgbtogray(left);
gray_mid = rgbtogray(mid);
gray_right = rgbtogray(right);

%Normalizing the Grayscale Images
left_norm = normalize(gray_left);
mid_norm = normalize(gray_mid);
right_norm = normalize(gray_right);

%Calculating the Points

%Left Image
points_left = detectSURFFeatures(left_norm);
[features_left, points_left] = extractFeatures(left_norm, points_left);

%Middle Image
points_mid = detectSURFFeatures(mid_norm);
[features_mid, points_mid] = extractFeatures(mid_norm, points_mid);

%Right Image
points_right = detectSURFFeatures(right_norm);
[features_right, points_right] = extractFeatures(right_norm, points_right);


midright_pair = matchFeatures(features_mid, features_right);
midleft_pair = matchFeatures(features_mid,features_left, "Unique", true);

midleft_matchedpoint = points_mid(midleft_pair(:,1),:);
left_matchedpoint = points_left(midleft_pair(:,2),:);
midright_matchedpoint = points_mid(midright_pair(:,1),:);
right_matchedpoint = points_right(midright_pair(:,2),:);


figure(1);
showMatchedFeatures(mid_norm, left_norm, midleft_matchedpoint, left_matchedpoint);
legend('Middle Matched Points', 'Left Matched Points');



figure(2);
showMatchedFeatures(mid_norm, right_norm, midright_matchedpoint, right_matchedpoint);
legend('middle matched points','right matched points');

figure(3); 
imshow(left_norm);
axis on;
hold on;
plot(left_matchedpoint([5,70,20,58]));
title('Left');

figure(4); 
imshow(mid_norm);
axis on;
hold on;
plot(midleft_matchedpoint([5,70,20,58]));
title('Middle Left');

figure(5); 
imshow(right_norm);
axis on;
hold on;
plot(right_matchedpoint([14,30,57,63]));
title('Right');

figure(6); 
imshow(mid_norm);
axis on;
hold on;
plot(midright_matchedpoint([14,30,57,63]));
title('Middle Right');

canvas_new = zeros(1032,2928,3);


canvas_new(310:741, 1:576, 1) = left(:,:,1);
canvas_new(310:741, 1:576, 2) = left(:,:,2);
canvas_new(310:741, 1:576, 3) = left(:,:,3);

canvas_new(310:741, 1186:1761, 1) = mid(:,:,1);
canvas_new(310:741, 1186:1761, 2) = mid(:,:,2);
canvas_new(310:741, 1186:1761, 3) = mid(:,:,3);

canvas_new(310:741, 2343:2918, 1) = right(:,:,1);
canvas_new(310:741, 2343:2918, 2) = right(:,:,2);
canvas_new(310:741, 2343:2918, 3) = right(:,:,3);

figure(7);
imshow(canvas_new/255);

left_x = left_matchedpoint.Location([5,70,20,58],1);
left_y = left_matchedpoint.Location([5,70,20,58],2);

midleft_x = midleft_matchedpoint.Location([5,70,20,58],1);
midleft_y = midleft_matchedpoint.Location([5,70,20,58],2);

midright_x = midright_matchedpoint.Location([14,30,57,63],1);
midright_y = midright_matchedpoint.Location([14,30,57,63],2);

right_x = right_matchedpoint.Location([14,30,57,63],1);
right_y = right_matchedpoint.Location([14,30,57,63],2);


left_x = left_x;
left_y = left_y + 310;

midleft_x = midleft_x + 1186;
midleft_y = midleft_y + 310;

midright_x = midright_x + 1186;
midright_y = midright_y + 310;

right_x = right_x + 2342;
right_y = right_y + 310;

A = [left_x(1)	    left_y(1)	    1	    0	    0	    0	-left_x(1)*midleft_x(1)	-left_y(1)*midleft_x(1);
        0	        0	    0	    left_x(1)	left_y(1)	1	-left_x(1)*midleft_y(1)	-left_y(1)*midleft_y(1);
    left_x(2)	    left_y(2)	    1	    0	    0	    0	-left_x(2)*midleft_x(2)	-left_y(2)*midleft_x(2);
        0	        0	    0	    left_x(2)	left_y(2)	1	-left_x(2)*midleft_y(2)	-left_y(2)*midleft_y(2);
    left_x(3)	    left_y(3)	    1	    0	    0	    0	-left_x(3)*midleft_x(3)	-left_y(3)*midleft_x(3);
        0	        0	    0	    left_x(3)	left_y(3)	1	-left_x(3)*midleft_y(3)	-left_y(3)*midleft_y(3);
    left_x(4)	    left_y(4)	    1	    0	    0	    0	-left_x(4)*midleft_x(4)	-left_y(4)*midleft_x(4);
        0	        0	    0	    left_x(4)	left_y(4)	1	-left_x(4)*midleft_y(4)	-left_y(4)*midleft_y(4)];


b = [midleft_x(1) midleft_y(1) midleft_x(2) midleft_y(2) midleft_x(3) midleft_y(3) midleft_x(4) midleft_y(4)]';
h = inv(A)*b;


H_left = [h(1) h(2) h(3);
     h(4) h(5) h(6);
     h(7) h(8) 1];

A = [right_x(1)	    right_y(1)	    1	    0	    0	    0	-right_x(1)*midright_x(1)	-right_y(1)*midright_x(1);
        0	        0	    0	    right_x(1)	right_y(1)	1	-right_x(1)*midright_y(1)	-right_y(1)*midright_y(1);
    right_x(2)	    right_y(2)	    1	    0	    0	    0	-right_x(2)*midright_x(2)	-right_y(2)*midright_x(2);
        0	        0	    0	    right_x(2)	right_y(2)	1	-right_x(2)*midright_y(2)	-right_y(2)*midright_y(2);
    right_x(3)	    right_y(3)	    1	    0	    0	    0	-right_x(3)*midright_x(3)	-right_y(3)*midright_x(3);
        0	        0	    0	    right_x(3)	right_y(3)	1	-right_x(3)*midright_y(3)	-right_y(3)*midright_y(3);
    right_x(4)	    right_y(4)	    1	    0	    0	    0	-right_x(4)*midright_x(4)	-right_y(4)*midright_x(4);
        0	        0	    0	    right_x(4)	right_y(4)	1	-right_x(4)*midright_y(4)	-right_y(4)*midright_y(4)];

b = [midright_x(1) midright_y(1) midright_x(2) midright_y(2) midright_x(3) midright_y(3) midright_x(4) midright_y(4)]';
h = inv(A)*b;


H_right = [h(1) h(2) h(3);
     h(4) h(5) h(6);
     h(7) h(8) 1];

canvas_new = zeros(1032,2928,3);


canvas_new(310:741, 1186:1761, 1) = mid(:,:,1);
canvas_new(310:741, 1186:1761, 2) = mid(:,:,2);
canvas_new(310:741, 1186:1761, 3) = mid(:,:,3);


figure(7);
imshow(canvas_new/255);



for j = 1:432
    for i = 1:576
        for k = 1:3

            x = j-0.5;
            y = (j+310)-0.5;

            [x2, y2] = H_trans(H_left, x, y);

            j_pan = round(y2-0.5);
            i_pan = round(x2+0.5);

            fprintf("j_pan:%f i_pan:%f\n", j_pan, i_pan);            

            if((j_pan >= 310 && j_pan <= 741) && (i_pan >= 1186 && i_pan <= 1761))
                canvas_new(j_pan, i_pan, k) = (canvas_new(j_pan, i_pan, k) + left(j,i,k))/2;
            else
                canvas_new(j_pan, i_pan, k) = left(j,i,k);
            end
        end
    end
end


for j = 1:432
    for i = 1:576
        for k = 1:3

            x = (j+2353)-0.5;
            y = (j+310)-0.5;

            [x2, y2] = H_trans(H_right, x, y);

            j_pan = round(y2-0.5);
            i_pan = round(x2+0.5);

            if((j_pan >= 310 && j_pan <= 741) && (i_pan >= 1186 && i_pan <= 1761))
                canvas_new(j_pan, i_pan, k) = (canvas_new(j_pan, i_pan, k) + right(j, i, k))/2;
            else
                canvas_new(j_pan, i_pan, k) = right(j,i,k);
            end
        end
    end
end



figure(7);
imshow(canvas_new/255);

canvas_2 = canvas_new;


for j = 2:1031
    for i = 2:2927
        for k = 1:3
            if canvas_new(j,i,k) == 0

                if canvas_new(j-1, i-1, k) ~= 0
                    canvas_2(j, i, k) = canvas_new(j-1, i-1, k);

                elseif canvas_new(j-1, i, k) ~= 0
                    canvas_2(j, i, k) = canvas_new(j-1,i,k);

                elseif canvas_new(j-1, i+1, k) ~= 0
                    canvas_2(j, i, k) = canvas_new(j-1, i+1, k);

                elseif canvas_new(j, i-1, k) ~= 0
                    canvas_2(j, i, k) = canvas_new(j, i-1, k);
                
                elseif canvas_new(j, i+1, k) ~= 0
                    canvas_2(j, i, k) = canvas_new(j, i+1, k);
                    
                elseif canvas_new(j+1, i-1, k) ~= 0
                    canvas_2(j, i, k) = canvas_new(j+1, i-1, k);

                elseif canvas_new(j+1, i+1, k) ~= 0
                    canvas_2(j, i, k) = canvas_new(j+1, i+1, k);

                elseif canvas_new(j+1, i, k) ~= 0
                    canvas_2(j, i, k) = canvas_new(j+1, i, k);
                end
            end
        end
    end
    
end
figure(8), imshow(uint8(canvas_2));
