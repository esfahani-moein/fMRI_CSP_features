function [out, accuracy, precision, recall, specificity, f1score, mcc, confusion_matrix] = classification_metrics(predicted_labels, true_labels)

% Calculate accuracy
accuracy = sum(predicted_labels == true_labels) / numel(true_labels);

% Calculate precision
TP = sum((predicted_labels == 1) & (true_labels == 1));
FP = sum((predicted_labels == 1) & (true_labels == 0));
precision = TP / (TP + FP);

% Calculate recall (sensitivity)
TN = sum((predicted_labels == 0) & (true_labels == 0));
FN = sum((predicted_labels == 0) & (true_labels == 1));
recall = TP / (TP + FN);

% Calculate specificity
specificity = TN / (TN + FP);

% Calculate F1 score
f1score = 2 * (precision * recall) / (precision + recall);

% Calculate Matthews Correlation Coefficient (MCC)
mcc = (TP * TN - FP * FN) / sqrt((TP + FP) * (TP + FN) * (TN + FP) * (TN + FN));

% Generate confusion matrix
confusion_matrix = confusionmat(true_labels, predicted_labels);

out.accuracy = accuracy;
out.precision = precision;
out.recall = recall;
out.specificity = specificity;
out.f1score = f1score;
out.mcc = mcc;
out.confusion_matrix = confusion_matrix;

end