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
import java.util.Collections;
import java.util.List;

import org.eclipse.update.core.IFeature;
import org.eclipse.update.core.VersionedIdentifier;
import org.eclipse.update.search.IUpdateSearchResultCollector;

/**
 * UpdateSearchResultCollector comparing features found with a base set of
 * features to find.
 */
public class FeatureVerifyingSearchCollector
  implements IUpdateSearchResultCollector
{

  private final List<VersionedIdentifier> featuresToFind = new ArrayList<VersionedIdentifier>();

  public FeatureVerifyingSearchCollector( final VersionedIdentifier[] listedFeatures )
  {
    Collections.addAll( this.featuresToFind, listedFeatures );
  }

  public void accept( final IFeature feature ) {
    this.featuresToFind.remove( feature.getVersionedIdentifier() );
  }

  /**
   * @return true if all the configured features are found, false otherwise.
   */
  public boolean allFeaturesFound() {
    return this.featuresToFind.isEmpty();
  }

  /**
   * @return the list of missing features
   */
  public VersionedIdentifier[] getMissingFeatures() {
    return this.featuresToFind.toArray( new VersionedIdentifier[ this.featuresToFind.size() ] );
  }
}