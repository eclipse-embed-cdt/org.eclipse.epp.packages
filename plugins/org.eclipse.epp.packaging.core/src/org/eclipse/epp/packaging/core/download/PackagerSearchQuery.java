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

import java.util.ArrayList;
import java.util.List;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.update.core.ISite;
import org.eclipse.update.core.ISiteFeatureReference;
import org.eclipse.update.core.VersionedIdentifier;
import org.eclipse.update.search.IQueryUpdateSiteAdapter;
import org.eclipse.update.search.IUpdateSearchFilter;
import org.eclipse.update.search.IUpdateSearchQuery;
import org.eclipse.update.search.IUpdateSearchResultCollector;

/** 
 * Search query looking for occurrences of configured features. 
 */
public class PackagerSearchQuery implements IUpdateSearchQuery {

  private final List<VersionedIdentifier> identifiers = new ArrayList<VersionedIdentifier>();

  public IQueryUpdateSiteAdapter getQuerySearchSite() {
    return null;
  }

  public void run( final ISite site,
                   final String[] categoriesToSkip,
                   final IUpdateSearchFilter filter,
                   final IUpdateSearchResultCollector collector,
                   final IProgressMonitor monitor )
  {
    ISiteFeatureReference[] featureReferences = site.getFeatureReferences();
    for( ISiteFeatureReference reference : featureReferences ) {
      try {
        if( this.identifiers.contains( reference.getVersionedIdentifier() ) ) {
          collector.accept( reference.getFeature( new NullProgressMonitor() ) );
        }
      } catch( CoreException ce ) {
        // The search is over, and there is nothing we could do about it.
      }
    }
  }

  /**
   * Add a feature to look for.
   */
  public void addFeatureIdentifier( final VersionedIdentifier identifier ) {
    this.identifiers.add( identifier );
  }
}