import React from 'react';
import Layout from '@theme/Layout';
import Mermaid from '@theme/Mermaid';
import HeroSection from '../components/HeroSection';
import { IconCard, BoxCard, CardGrid } from '../components/Cards';
import CollectionCard from '../components/CollectionCards';
import { iconCards, boxCards } from '../data/hubCards';
import { collectionCards } from '../data/collectionCards';

const collectionDiagram = `graph TD
    HCA["hve-core-all<br/>(163 artifacts)"]
    INS["installer<br/>(2 artifacts)"]
    ADO["ado"] CS["coding-standards"] DS["data-science"]
    DT["design-thinking"] EXP["experimental"] GH["github"]
    HC["hve-core"] PP["project-planning"] SP["security-planning"]
    HCA --> ADO
    HCA --> CS
    HCA --> DS
    HCA --> DT
    HCA --> EXP
    HCA --> GH
    HCA --> HC
    HCA --> PP
    HCA --> SP`;

export default function Home(): React.ReactElement {
  return (
    <Layout title="HVE Core" description="AI-Driven Software Development Across the Full Lifecycle">
      <HeroSection
        title="HVE Core"
        subtitle="AI-Driven Software Development Across the Full Lifecycle"
      />

      <main>
        <section style={{ padding: '24px 0', maxWidth: 'calc(100% - 48px)', margin: '0 24px' }}>
          <CardGrid>
            {iconCards.map((card) => (
              <IconCard key={card.href} icon={card.icon} supertitle={card.supertitle} title={card.title} href={card.href} />
            ))}
          </CardGrid>
        </section>

        <section style={{ padding: '48px 0', maxWidth: 'calc(100% - 48px)', margin: '0 24px' }}>
          <h2 style={{ fontSize: '34px', fontWeight: 600, marginBottom: '0px' }}>Deep dive</h2>
          <p style={{ color: 'var(--ms-learn-text-subtle)', marginTop: '0', marginBottom: '24px', fontSize: '16px' }}>
            Explore best practices and patterns for AI-assisted development.
          </p>
          <CardGrid columns={4}>
            {boxCards.map((card) => (
              <BoxCard key={card.title} {...card} />
            ))}
          </CardGrid>
        </section>

        <section style={{ padding: '48px 0', maxWidth: 'calc(100% - 48px)', margin: '0 24px' }}>
          <h2 style={{ fontSize: '34px', fontWeight: 600, marginBottom: '0px' }}>Collections</h2>
          <p style={{ color: 'var(--ms-learn-text-subtle)', marginTop: '0', marginBottom: '24px', fontSize: '16px' }}>
            Browse domain-specific artifact bundles.
          </p>
          <CardGrid>
            {collectionCards.map((card) => (
              <CollectionCard key={card.name} {...card} />
            ))}
          </CardGrid>
          <div style={{ marginTop: '2rem', display: 'flex', justifyContent: 'center' }}>
            <Mermaid value={collectionDiagram} />
          </div>
        </section>
      </main>
    </Layout>
  );
}
