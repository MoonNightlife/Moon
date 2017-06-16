/*
 * Copyright (c) 2016 Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#ifndef SIN_LOG_SEVERITY_H
#define SIN_LOG_SEVERITY_H

#ifndef SIN_LOG_SEVERITY_
#define SIN_LOG_SEVERITY_
typedef NS_ENUM(NSInteger, SINVLogSeverity) {
  SINVLogSeverityTrace = 0,
  SINVLogSeverityInfo,
  SINVLogSeverityWarning,
  SINVLogSeverityCritical
};
#endif  // SIN_LOG_SEVERITY_

#endif  // SIN_LOG_SEVERITY_H
