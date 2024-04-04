import 'package:gas_leakage_survey/data/raise_ticket_data.dart';

List<String> generateItemsBasedOnTypeOfLeakPipeline(String selectedTypeOfLeak) {
  if (selectedTypeOfLeak == 'Underground') {
    return pipelineUG;
  } else if (selectedTypeOfLeak == 'Above Ground') {
    return pipelineAG;
  } else {
    return [];
  }
}

List<String> generateItemsBasedOnPressureOfPipeline(String selectedTypeOfLeak) {
  if (selectedTypeOfLeak == 'Underground') {
    return pressureOfPipelineUG;
  } else if (selectedTypeOfLeak == 'Above Ground') {
    return pressureOfPipelineAG;
  } else {
    return [];
  }
}

List<String> generateItemsBasedOnPipelineDistribution(String selectedTypeOfLeak) {
  if (selectedTypeOfLeak == 'Underground') {
    return pipelineDistributionUG;
  } else if (selectedTypeOfLeak == 'Above Ground') {
    return pipelineDistributionAG;
  } else {
    return [];
  }
}

List<String> generateItemsBasedOnSourceOfLeak(String selectedTypeOfLeak) {
  if (selectedTypeOfLeak == 'Underground') {
    return [];
  } else if (selectedTypeOfLeak == 'Above Ground') {
    return sourceOfLeakAG;
  } else {
    return [];
  }
}

List<String> generateItemsBasedOnLocationOfPipe(String selectedTypeOfLeak) {
  if (selectedTypeOfLeak == 'Underground') {
    return locationOfPipeUG;
  } else if (selectedTypeOfLeak == 'Above Ground') {
    return locationOfPipeAG;
  } else {
    return [];
  }
}
List<String> generateItemsBasedOnSourceOfLeakageAfterDigging(String selectedTypeOfLeak) {
  if (selectedTypeOfLeak == 'Underground') {
    return sourceOfLeakageAfterDiggingUG;
  } else if (selectedTypeOfLeak == 'Above Ground') {
    return sourceOfLeakageAfterDiggingAG;
  } else {
    return [];
  }
}

List<String> generateItemsBasedOnSourceOfProbableCauseOfLeakAfterDigging(String selectedTypeOfLeak) {
  if (selectedTypeOfLeak == 'Underground') {
    return probableCauseOfLeakAfterDiggingUG;
  } else if (selectedTypeOfLeak == 'Above Ground') {
    return probableCauseOfLeakAfterDiggingAG;
  } else {
    return [];
  }
}

List<String> generateItemsBasedOnPipelineDistributionType(String selectedPipelineDistributionType, String selectedTypeOfLeak) {
  if (selectedPipelineDistributionType == 'Service') {
    if (selectedTypeOfLeak == 'Underground') {
      return diameterOfPipelineUGService;
    } else if (selectedTypeOfLeak == 'Above Ground') {
      return diameterOfPipelineAGService;
    }
  } else if (selectedPipelineDistributionType == 'Distribution') {
    return diameterOfPipelineUGDistribution;
  } else if (selectedPipelineDistributionType == 'Branch') {
    return diameterOfPipelineUGBranch;
  } else if (selectedPipelineDistributionType == 'Mains') {
    return diameterOfPipelineUGMains;
  }
  return []; // Added return statement
}


//buttons actions
