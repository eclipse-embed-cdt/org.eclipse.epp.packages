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
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.core.runtime.OperationCanceledException;
import org.eclipse.update.core.VersionedIdentifier;
import org.eclipse.update.search.IUpdateSearchResultCollector;
import org.eclipse.update.search.UpdateSearchRequest;
import org.eclipse.update.search.UpdateSearchScope;

/**
 * Handles and executes the search for a set of features over a number of update
 * sites.
 */
public class FeatureSearcher {

  private final UpdateSearchScope scope = new UpdateSearchScope();
  private final PackagerSearchCategory category = new PackagerSearchCategory();

  public FeatureSearcher( final VersionedIdentifier[] listedFeatures,
                          final URL[] listedSites )
  {
    for( VersionedIdentifier identifier : listedFeatures ) {
      this.category.addFeatureToSearch( identifier );
    }
    for( URL siteUrl : listedSites ) {
      this.scope.addSearchSite( "", siteUrl, null ); //$NON-NLS-1$
    }
  }

  /**
   * Run the search.
   * 
   * @param collector the collector storing the search results.
   */
  public void run( final IUpdateSearchResultCollector collector )
    throws OperationCanceledException, CoreException
  {
    UpdateSearchRequest searchRequest 
      = new UpdateSearchRequest( this.category, this.scope );
    searchRequest.performSearch( collector, new NullProgressMonitor() );
  }
}