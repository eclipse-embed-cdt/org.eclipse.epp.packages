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

import java.io.File;
import java.net.URL;
import org.eclipse.update.core.VersionedIdentifier;

/**
 * Provides all data the Eclipse Packager requires to run.
 */
public interface IPackagerConfiguration {

  public URL[] getUpdateSites();

  public VersionedIdentifier[] getRequiredFeatures();

  public File getPackagerConfigurationFolder();

  public String getInstallerConfigurationFolder();

  public File getTargetFolder();

  public File getExtensionSite();

  public IPlatform[] getTargetPlatforms();

  public String getRootFileBaseName();

  public File getRootFileFolder();

  public File getConfigIni();

  public String getProductName();
}