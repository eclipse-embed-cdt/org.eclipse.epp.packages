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

import java.io.IOException;
import java.net.MalformedURLException;

import junit.framework.Assert;
import junit.framework.TestCase;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.epp.packaging.core.DummyPackagerConfiguration;
import org.eclipse.epp.packaging.core.download.UpdateSiteManager;
import org.eclipse.update.core.IFeature;
import org.eclipse.update.core.VersionedIdentifier;

/** Test class*/
public class UpdateSiteManager_PdeTest extends TestCase {

  private static final String BUCKMINSTER_UPDATESITE_URL 
    = "http://download.eclipse.org/technology/buckminster/updates/"; //$NON-NLS-1$
  private static final VersionedIdentifier BUCKMINSTERIDENTIFIER 
    = new VersionedIdentifier( "org.eclipse.buckminster.core.feature", //$NON-NLS-1$
                               "1.0.0.v20070220" ); //$NON-NLS-1$
  private static final VersionedIdentifier HEADLESSIDENTIFIER 
    = new VersionedIdentifier( "org.eclipse.buckminster.svn.headless.feature", //$NON-NLS-1$
                               "1.0.0.v20070207" ); //$NON-NLS-1$
  private DummyPackagerConfiguration configuration;
  private UpdateSiteManager manager;

  @Override
  protected void setUp() throws Exception {
    super.setUp();
    this.configuration = new DummyPackagerConfiguration();
    this.configuration.setUpdateSite( BUCKMINSTER_UPDATESITE_URL );
    this.configuration.addRequiredFeature( BUCKMINSTERIDENTIFIER );
    this.configuration.addRequiredFeature( HEADLESSIDENTIFIER );
    this.manager = new UpdateSiteManager( this.configuration );
  }

  // For some reason, this fails with the local update site.
  public void testGetFeature()
    throws CoreException, MalformedURLException, IOException
  {
    IFeature[] feature = this.manager.getFeatures();
    Assert.assertEquals( 2, feature.length );
  }

  public void testAllFeaturesPresent()
    throws MalformedURLException, IOException, CoreException
  {
    this.manager = new UpdateSiteManager( this.configuration );
    Assert.assertTrue( this.manager.areFeaturesPresent( new VersionedIdentifier[]{
      BUCKMINSTERIDENTIFIER, HEADLESSIDENTIFIER
    } ) );
  }
}
