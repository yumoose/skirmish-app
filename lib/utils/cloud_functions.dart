import 'package:cloud_functions/cloud_functions.dart';

// A useful default to get cloud functions deployed to Aussie SE1
FirebaseFunctions get cloudFunctions => FirebaseFunctions.instanceFor(
      region: 'australia-southeast1',
    );
