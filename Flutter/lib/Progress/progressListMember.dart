


import '/Progress/PersonGeneralData.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

import 'package:percent_indicator/percent_indicator.dart';
import 'workoutProgramData.dart';

class ProgressListMember extends StatefulWidget {
  const ProgressListMember({super.key,required this.exercise,required this.value});
  final String exercise;
  final int value;
  @override
  State<ProgressListMember> createState() => _ProgressListMember();
}
class _ProgressListMember extends State<ProgressListMember> {
  @override
  Widget build(BuildContext context) {
    String exercise = widget.exercise;
    List<int> yData =[];
    if (widget.value ==0){

    }
    else{
      yData = GeneralDataList.getData(exercise);
    }
    double res = yData.last.toDouble();
    double lastRes = yData.elementAt((yData.length) -2).toDouble();
    int improvement = (((res - lastRes) / lastRes) * 100).round();
    IconData currentIcon = improvement >=0 ? Icons.trending_up_rounded :Icons.trending_down_rounded;
    improvement = improvement >=0 ? improvement : -improvement ;

    return
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
              16.0, 0.0, 16.0, 0.0),
          child: Container(
            width: 100.0,
            height: 120.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context)
                  .secondaryBackground,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 3.0,
                  color: Color(0x33000000),
                  offset: Offset(
                    0.0,
                    1.0,
                  ),
                )
              ],
              borderRadius:
              BorderRadius.circular(12.0),
              border: Border.all(
                color:
                FlutterFlowTheme.of(context)
                    .alternate,
                width: 1.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    '$exercise',
                    style: FlutterFlowTheme.of(
                        context)
                        .labelMedium
                        .override(
                      fontFamily:
                      'Readex Pro',
                      letterSpacing: 0.0,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisSize:
                      MainAxisSize.max,
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: [
                        Align(
                          alignment:
                          const AlignmentDirectional(
                              -1.0, 1.0),
                          child: RichText(
                            textScaler:
                            MediaQuery.of(
                                context)
                                .textScaler,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '$res',
                                  style: FlutterFlowTheme.of(
                                      context)
                                      .displayMedium
                                      .override(
                                    fontFamily:
                                    'Outfit',
                                    letterSpacing:
                                    0.0,
                                  ),
                                ),
                                 TextSpan(
                                  text:
                                  '\n $improvement% than last week',
                                  style:
                                  TextStyle(),
                                )
                              ],
                              style: FlutterFlowTheme
                                  .of(context)
                                  .labelMedium
                                  .override(
                                fontFamily:
                                'Readex Pro',
                                color: FlutterFlowTheme.of(
                                    context)
                                    .tertiary,
                                letterSpacing:
                                0.0,
                              ),
                            ),
                          ),
                        ),
                        Icon(
                            currentIcon,
                          color:
                          FlutterFlowTheme.of(
                              context)
                              .tertiary,
                          size: 24.0,
                        ),
                        Expanded(
                          child: Align(
                            alignment:
                            const AlignmentDirectional(
                                1.0, 0.0),
                            child:
                            CircularPercentIndicator(
                              percent: 0.01 * improvement,
                              radius: 35.0,
                              lineWidth: 8.0,
                              animation: true,
                              animateFromLastPercent:
                              true,
                              progressColor:
                              FlutterFlowTheme.of(
                                  context)
                                  .tertiary,
                              backgroundColor:
                              const Color(
                                  0xFFF0D0C3),
                              center: Text(
                                '$improvement%',
                                style: FlutterFlowTheme
                                    .of(context)
                                    .bodyLarge
                                    .override(
                                  fontFamily:
                                  'Readex Pro',
                                  letterSpacing:
                                  0.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ].divide(
                          const SizedBox(width: 4.0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
