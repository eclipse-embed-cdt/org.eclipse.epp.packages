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

import java.net.URL;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.epp.packaging.core.configuration.IPackagerConfiguration;
import org.eclipse.epp.packaging.core.logging.MessageLogger;
import org.eclipse.update.core.IFeature;
import org.eclipse.update.core.VersionedIdentifier;
import org.eclipse.update.search.IUpdateSearchResultCollector;

/**
 * Holds references to a list of update sites and provides the methods required
 * for interaction.
 */
public class UpdateSiteManager implements IUpdateSiteManager {

  private final URL[] listedSites;
  private final VersionedIdentifier[] listedFeatures;

  public UpdateSiteManager( final IPackagerConfiguration configuration ) {
    this.listedSites = configuration.getUpdateSites();
    this.listedFeatures = configuration.getRequiredFeatures();
    MessageLogger.getInstance().log( "UpdateSiteManager.ListedSitesCount", //$NON-NLS-1$
                                     Integer.valueOf( this.listedSites.length ) );
  }

  public boolean areFeaturesPresent( final VersionedIdentifier[] identifiers )
    throws CoreException
  {
    MessageLogger.getInstance().logBeginProcess( "UpdateSiteManager.FeatureLookup" ); //$NON-NLS-1$
    FeatureVerifyingSearchCollector collector 
      = new FeatureVerifyingSearchCollector( this.listedFeatures );
    search( collector );
    boolean result = collector.allFeaturesFound();
    if( result ) {
      MessageLogger.getInstance().logEndProcess( "UpdateSiteManager.FeaturesPresent" ); //$NON-NLS-1$
    } else {
      MessageLogger.getInstance().logEndProcess( "UpdateSiteManager.FeaturesMissing" ); //$NON-NLS-1$
      for( VersionedIdentifier feature : collector.getMissingFeatures() ) {
        MessageLogger.getInstance().log( feature.toString() );
      }
    }
    return result;
  }

  public IFeature[] getFeatures() throws CoreException {
    FeatureRetrievingSearchCollector collector = new FeatureRetrievingSearchCollector();
    search( collector );
    return collector.getFeatures();
  }

  private void search( final IUpdateSearchResultCollector collector )
    throws CoreException
  {
    FeatureSearcher featureSearcher = new FeatureSearcher( this.listedFeatures,
                                                           this.listedSites );
    featureSearcher.run( collector );
  }
}