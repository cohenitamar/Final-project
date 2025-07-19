
import '/flutter_flow/flutter_flow_theme.dart';
import 'PersonGeneralData.dart';

import 'package:flutter/material.dart';


class GeneralProgressListMember extends StatefulWidget {
  const GeneralProgressListMember({super.key, required this.data, required this.onTab});
  final GeneralData data;
  final void Function(String) onTab;

  @override
  State<GeneralProgressListMember> createState() => _GeneralProgressListMember();
}


class _GeneralProgressListMember extends State<GeneralProgressListMember> {
  @override
  Widget build(BuildContext context) {
    GeneralData data =widget.data;
    String name = data.dataName;
    DataByDate d = GeneralDataList.getLastData(data.dataName);
    int lastData = d.weight;
    String measure = data.measurementUnites;
    return
      Expanded(
        child: Container(
          width: 100.0,
          height: 170.0,
          decoration: BoxDecoration(
            color:
            FlutterFlowTheme.of(context)
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
                  '$name',
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
                  child: Align(
                    alignment:
                    const AlignmentDirectional(
                        -1.0, 0.0),
                    child: RichText(
                      textScaler:
                      MediaQuery.of(
                          context)
                          .textScaler,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$lastData',
                            style: FlutterFlowTheme
                                .of(context)
                                .displayMedium
                                .override(
                              fontFamily:
                              'Outfit',
                              letterSpacing:
                              0.0,
                            ),
                          ),
                           TextSpan(
                            text: '$measure',
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
                          letterSpacing:
                          0.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1.0,
                  color: FlutterFlowTheme.of(
                      context)
                      .alternate,
                ),
                InkWell(
                  onTap: () {
                    // Your onTap function here
                    widget.onTab(name);
                    // You can navigate to another page, show a dialog, etc.
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'View Now',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                          color: FlutterFlowTheme.of(context).tertiary,
                          letterSpacing: 0.0,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

}