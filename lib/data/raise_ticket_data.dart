//Raising ticket form data
String baseUrl = 'https://picarro-backend.onrender.com';
// String baseUrl = 'http://127.0.0.1:5000/';
// String baseUrl = 'https://f1d0-2409-40c1-10d2-862-c999-3ae6-8f25-69d7.ngrok-free.app/';
String loginEndpoint = '/clients/login';
String createTicketEndpoint = '/tickets/create';

const OPENWEATHER_API_KEY = "640b74138a4b83ff1bf4f78ddf113b93";

String? tokenUser = "";
String? photographOfLocationPoint = "";
String? video = "";
String? coordinatesOfLeakagePoint = "";
String? addressAsPerGoogle = "";
String? windDirectionAndSpeed = "";
String? weatherTemperature = "";
String? organizationId = "dummyOrganizationText";
String? createBy = "";
String? assignTo = "Assign To";

List<String> DataFields = [
  'Type of Leak',
  'Consumer Type',
  'Leak first detected through',
  'Pipeline',
  'Pressure of Pipeline',
  'Pipeline distribution Type',
  'Diameter of Pipeline',
  'Source of leak',
  'Location of Pipe',
  'Cover of Pipeline',
  'Source of Leakage (After Digging)',
  'Probable Cause of leak (After Digging)',
  'Leak grading'
];

final List<String> typeOfLeak = [
  'Underground',
  'Aboveground',
];
final List<String> consumerType = [
  'Residence',
  'Commercial',
  'Industrial',
  'Open Area',
];
List<String> consumerTypeIcon = [
  'assets/images/Residence.png',
  'assets/images/Commercial.png',
  'assets/images/Industrial.png',
  'assets/images/OpenArea.png',
  // Add more image paths as needed
];

final List<String> leakFirstDetectedThrough = [
  'RMLD',
  'DPIR',
];
List<String> leakFirstDetectedThroughIcon = [
  'assets/images/RMLD.png',
  'assets/images/DPIR.png',
];
final List<String> pipelineUG = [
  'MDPE',
  'SS',
  'GI',
];
List<String> pipelineUGIcon = [
  'assets/images/MDPE.png',
  'assets/images/SS.png',
  'assets/images/GE.png',
];
final List<String> pipelineAG = [
  'GI',
];
List<String> pipelineAGIcon = [
  'assets/images/GE.png',
];
final List<String> pressureOfPipelineUG = [
  'Bar',
  'Bar',
  'Bar',
  'Bar',
  'Bar',
  'Bar',
  'Bar',
  'Bar',
  'm Bar',
];
final List<String> pressureOfPipelineUGNumber = [
  '4',
  '3.5',
  '3',
  '2.5',
  '2',
  '1.5',
  '1',
  '0.5',
  '110',
];
final List<String> pressureOfPipelineAG = [
  'Bar',
  'Bar',
  'Bar',
  'Bar',
  'Bar',
  'Bar',
  'Bar',
  'Bar',
  'm Bar',
  'm Bar',
];
final List<String> pressureOfPipelineAGNumber = [
  '4',
  '3.5',
  '3',
  '2.5',
  '2',
  '1.5',
  '1',
  '0.5',
  '110',
  '21'
];
final List<String> pipelineDistributionUG = [
  'Service',
  'Distribution',
  'Branch',
  'Mains',
];
List<String> pipelineDistributionUGIcon = [
  'assets/images/Service.png',
  'assets/images/Distribution.png',
  'assets/images/Branch.png',
  'assets/images/Mains.png',
];
final List<String> pipelineDistributionAG = [
  'Service',
];
List<String> pipelineDistributionAGIcon = [
  'assets/images/Service.png',
];
final List<String> diameterOfPipelineUGService = [
  'mm',
  'mm',
  'mm',
];
final List<String> diameterOfPipelineUGServiceNumber = [
  '20',
  '32',
  '63',
];
final List<String> diameterOfPipelineUGDistribution = [
  'mm',
  'mm',
];
final List<String> diameterOfPipelineUGDistributionNumber = [
  '32',
  '63',
];
final List<String> diameterOfPipelineUGBranch = [
  'mm',
  'mm',
  'mm',
];
final List<String> diameterOfPipelineUGBranchNumber = [
  '63',
  '90',
  '125',
];
final List<String> diameterOfPipelineUGMains = [
  'mm',
  'mm',
];
final List<String> diameterOfPipelineUGMainsNumber = [
  '125',
  '180',
];
final List<String> diameterOfPipelineAGService = [
  'mm',
  'mm',
  'mm',
  'mm',
];
final List<String> diameterOfPipelineAGServiceNumber = [
  '12',
  '18',
  '25',
  '37',
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
  'Coupler',
  'TEE',
];
List<String> sourceOfLeakAGIcon = [
  'assets/images/TF.png',
  'assets/images/GE.png',
  'assets/images/Union.png',
  'assets/images/RegulatorInlet.png',
  'assets/images/RegulatorBody.png',
  'assets/images/RegulatorOutlet.png',
  'assets/images/Elbow.png',
  'assets/images/MeterInlet.png',
  'assets/images/MeterOutlet.png',
  'assets/images/Anaconda.png',
  'assets/images/Coupler.png',
  'assets/images/TEE.png',
];
final List<String> locationOfPipeUG = [
  'Street ',
  'Between Street & Sidewalk',
  'Under Sidewalk',
  'Lawn',
  'Basement',
  'Others',
];
List<String> locationOfPipeUGIcon = [
  'assets/images/Street.png',
  'assets/images/BetweenStreetSidewalk.png',
  'assets/images/UnderSidewalk.png',
  'assets/images/Lawn.png',
  'assets/images/Basement.png',
  'assets/images/Others.png',
];
final List<String> locationOfPipeAG = [
  'Inside Premises ',
  'Outside Premises',
  'Basement',
];
List<String> locationOfPipeAGIcon = [
  'assets/images/InsidePremises.png',
  'assets/images/OutsidePremises.png',
  'assets/images/Basement.png',
];
final List<String> coverOfPipeline = [
  'Concrete ',
  'Asphalt',
  'Brick',
  'Gravel',
  'Soil',
  'Others',
];
List<String> coverOfPipelineIcon = [
  'assets/images/Concrete.png',
  'assets/images/Asphalt.png',
  'assets/images/Brick.png',
  'assets/images/Gravel.png',
  'assets/images/Soil.png',
  'assets/images/Others.png',
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
List<String> sourceOfLeakageAfterDiggingUGIcon = [
  'assets/images/Coupler.png',
  'assets/images/PipelineDamage.png',
  'assets/images/TEE.png',
  'assets/images/Saddle.png',
  'assets/images/SaddleCap.png',
  'assets/images/EndCap.png',
  'assets/images/TFFusion.png',
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
  'Coupler',
  'TEE',
];
List<String> sourceOfLeakageAfterDiggingAGIcon = [
  'assets/images/TF.png',
  'assets/images/GE.png',
  'assets/images/Union.png',
  'assets/images/RegulatorInlet.png',
  'assets/images/RegulatorBody.png',
  'assets/images/RegulatorOutlet.png',
  'assets/images/Elbow.png',
  'assets/images/MeterInlet.png',
  'assets/images/MeterOutlet.png',
  'assets/images/Anaconda.png',
  'assets/images/Coupler.png',
  'assets/images/TEE.png',
];
final List<String> probableCauseOfLeakAfterDiggingUG = [
  'Third Party Damage ',
  'Material Failure',
  'Workmanship Issue',
  'Rat Bite',
];
List<String> probableCauseOfLeakAfterDiggingUGIcon = [
  'assets/images/ThirdPartyDamage.png',
  'assets/images/MaterialFailure.png',
  'assets/images/WorkmanshipIssue.png',
  'assets/images/RatBite.png',
];
final List<String> probableCauseOfLeakAfterDiggingAG = [
  'Corrosion',
  'Material Failure',
  'Workmanship Issue',
  'O Ring',
];
List<String> probableCauseOfLeakAfterDiggingAGIcon = [
  'assets/images/Corrosion.png',
  'assets/images/MaterialFailure.png',
  'assets/images/WorkmanshipIssue.png',
  'assets/images/ORing.png',
];
final List<String> leakGrading = [
  'Grade',
  'Grade',
  'Grade',
];
final List<String> leakGradingNumber = [
  '1',
  '2',
  '3',
];
