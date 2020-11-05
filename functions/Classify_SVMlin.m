function [labelm,classificationSVM,label,AUC,validationScores]=Classify_SVMlin(TD,rep);

%% read in training data
[H,W]=size(TD);

for i=1:W
    inputcolumns{i}=['column_',num2str(i)];
end

inputTable = array2table(TD, 'VariableNames', inputcolumns);
predictorNames = inputcolumns(1:end-1);
predictors=inputTable(:,predictorNames);
responseName=inputcolumns{end};
eval(['response = inputTable.',responseName,';'])

numberClass=unique(response);

%% Train a classifier

template = templateSVM('KernelFunction', 'linear','PolynomialOrder', [],'KernelScale', 'auto', 'BoxConstraint', 100, 'Standardize', true,'SaveSupportVectors',true);
classificationSVM = fitcecoc(predictors,response,'Learners', template,'Coding', 'onevsone','ClassNames', numberClass);
    
% create the result struct with predict function
predictorExtractionFcn = @(x) array2table(x, 'VariableNames', predictorNames);
ensemblePredictFcn = @(x) predict(classificationSVM, x);
trainedClassifier.predictFcn = @(x) ensemblePredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedClassifier.classifier = classificationSVM;
trainedClassifier.About = 'This struct is a trained classifier exported from Classification Learner R2016b.';
trainedClassifier.HowToPredict = sprintf('To make predictions on a new predictor column matrix, X, use: \n  yfit = c.predictFcn(X) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedClassifier''. \n \nX must contain exactly 343 columns because this classifier was trained using 343 predictors. \nX must contain only predictor columns in exactly the same order and format as your training \ndata. Do not include the response column or any columns you did not import into \nClassification Learner. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>.');


for j=1:rep
    rng(j); % set the range to make the results reproducible
    % Perform cross-validation
    partitionedModel = crossval(trainedClassifier.classifier, 'KFold', 10);
    [label(:,j),validationScores]=kfoldPredict(partitionedModel);
       if length(numberClass)==2
        [~,~,~,AUC(j)]=perfcurve(response,validationScores(:,1),0);
    else
        for jj=1:length(numberClass)
            [~,~,~,AUC(j,jj)]=perfcurve(response,validationScores(:,jj),numberClass(jj));
        end
    end
end

labelm=mode(label,2);    % most prevalent value

end