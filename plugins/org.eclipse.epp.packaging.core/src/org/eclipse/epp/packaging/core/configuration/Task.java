/*******************************************************************************
 * Copyright (c) 2007 Innoopract Informationssysteme GmbH
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *    Innoopract - initial API and implementation
 *******************************************************************************/
package org.eclipse.epp.packaging.core.configuration;

/**
 * Enumerates the three tasks known to the Eclipse Packager.
 */
public enum Task {
  /** Verifies requested features against the installation sites. */
  CHECK,
  /** Installs the requested features to the local extension site. */
  INSTALL,
  /** Builds the application from the requested features and the root files. */
  BUILD
}