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

