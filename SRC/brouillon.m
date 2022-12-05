for i=1:3
diff(:,i)=data(:,i+1)-data_c(:,i);
end

figure
subplot(311)
plot(data_c(:,1))
ylim([min(x) max(x)])
subplot(312)
plot(data_c(:,2))
ylim([min(y) max(y)])
subplot(313)
plot(data_c(:,3))
ylim([min(z) max(z)])

%% filtrage
[B,A] = butter(4, [0.5 20] ./ (Fs / 2)); 
filtered_enmo = filter(B, A, enmo);

svm = sqrt(sum(data(:, end-2:end) .^ 2, 2)) - 1;

svm = SVM(data, Fs, 0.5, 20);	% Filtre passe bande 0,5 à 20 Hz

%% affichage des filtrages

[B,A] = butter(4, [0.5 20] ./ (Fs_ori / 2));
filtered_enmo1 = filter(B, A, enmo);
for i=1:size(time)
if filtered_enmo1(i)<0
filtered_enmo1(i)=0;
end
end
figure
subplot(311)
plot(enmo)
title('enmo')
subplot(312)
plot(filtered_enmo)
title('enmo des données filtrées')
subplot(313)
plot(filtered_enmo1)
title('enmo après filtration')

%% moyennes epoch

window=1:60*Fs:size(time,1); % donne le début de chaque fenêtre epoch de 60 sec

for i = 1:size(window,2)-1
moyepoch(i)=mean(enmo(window(i):window(i)+5999));
end

figure
plot(moyepoch,window-1)

    