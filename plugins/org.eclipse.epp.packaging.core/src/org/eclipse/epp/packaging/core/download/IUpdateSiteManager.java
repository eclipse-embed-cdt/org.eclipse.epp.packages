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
package org.eclipse.epp.packaging.core.download;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.update.core.IFeature;
import org.eclipse.update.core.VersionedIdentifier;

/**
 * Responsible for managing the declared update sites.
 */
public interface IUpdateSiteManager {

  /**
   * Checks whether all of the features given by identifiers are present on the
   * managed update sites.
   * 
   * @return true, if all identified features can be found, false otherwise.
   */
  public boolean areFeaturesPresent( VersionedIdentifier[] identifiers )
    throws CoreException;

  /** Returns the IFeatures for the configured feature references
   */
  public IFeature[] getFeatures() throws CoreException;
}