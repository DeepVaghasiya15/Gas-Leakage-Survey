//Raising ticket form data

List<String> DataFields = ['Type of leak','Consumer Type','Leak first detected through','Pipeline','Pressure of Pipeline','Pipeline distribution Type','Diameter of Pipeline','Source of leak','Location of Pipe','Cover of Pipeline','Source of Leakage (After Digging)','Probable Cause of leak (After Digging)','Leak grading'];

final List<String> typeOfLeak = [
  'Underground',
  'Above Ground',
];
final List<String> consumerType = [
  'Residence',
  'Commercial',
  'Industrial',
  'Open Area',
];
final List<String> leakFirstDetectedThrough = [
  'RMLD',
  'DPIR',
];
final List<String> pipelineUG = [
  'MDPE',
  'SS',
  'GE',
];
final List<String> pipelineAG = [
  'GE',
];
final List<String> pressureOfPipelineUG = [
  '4 Bar',
  '3.5 Bar',
  '3 Bar',
  '2.5 Bar',
  '2 Bar',
  '1.5 Bar',
  '1 Bar',
  '0.5 Bar',
  '110 m Bar',
];
final List<String> pressureOfPipelineAG = [
  '4 Bar',
  '3.5 Bar',
  '3 Bar',
  '2.5 Bar',
  '2 Bar',
  '1.5 Bar',
  '1 Bar',
  '0.5 Bar',
  '110 m Bar',
  '21 m Bar'
];
final List<String> pipelineDistributionUG = [
  'Service',
  'Distribution',
  'Branch',
  'Mains',
];
final List<String> pipelineDistributionAG = [
  'Service',
];
final List<String> diameterOfPipelineUGService = [
  '20 mm',
  '32 mm',
  '63 mm',
];
final List<String> diameterOfPipelineUGDistribution = [
  '32 mm',
  '63 mm',
];
final List<String> diameterOfPipelineUGBranch = [
  '63 mm',
  '90 mm',
  '125 mm',
];
final List<String> diameterOfPipelineUGMains = [
  '125 mm',
  '180 mm',
];
final List<String> diameterOfPipelineAGService = [
  '12 mm',
  '18 mm',
  '25 mm',
  '37 mm',
];
final List<String> sourceOfLeakAG = [
  'TF',
  'IV',
  'Union',
  'Regulator Inlet',
  'Regulator Body',
  'Regulator Outlet',
  'Elbow',
  'Meter Inlet',
  'Meter Outlet',
  'Anaconda',
  'Elbow',
  'Coupler',
  'TEE',
];
final List<String> locationOfPipeUG = [
  'Street ',
  'Between Street & Sidewalk',
  'Under Sidewalk',
  'Lawn',
  'Basement',
  'Others',
];
final List<String> locationOfPipeAG = [
  'Inside Premises ',
  'Outside Premises',
  'Basement',
];
final List<String> coverOfPipeline = [
  'Concrete ',
  'Asphalt',
  'Brick',
  'Gravel',
  'Soil',
  'Others',
];
final List<String> sourceOfLeakageAfterDiggingUG = [
  'Coupler ',
  'Pipeline Damage',
  'TEE',
  'Saddle',
  'Saddle Cap',
  'End Cap',
  'TF Fusion'
];
final List<String> sourceOfLeakageAfterDiggingAG = [
  'TF',
  'IV',
  'Union',
  'Regulator Inlet',
  'Regulator Body',
  'Regulator Outlet',
  'Elbow',
  'Meter Inlet',
  'Meter Outlet',
  'Anaconda',
  'Elbow',
  'Coupler',
  'TEE',
];
final List<String> probableCauseOfLeakAfterDiggingUG = [
  'Third Party Damage ',
  'Material Failure',
  'Workmanship Issue',
  'Rat Bite',
];
final List<String> probableCauseOfLeakAfterDiggingAG = [
  'Corrosion',
  'Material Failure',
  'Workmanship Issue',
  'O Ring',
];
final List<String> leakGrading = [
  'Grade-1',
  'Grade-2',
  'Grade-3',
];

