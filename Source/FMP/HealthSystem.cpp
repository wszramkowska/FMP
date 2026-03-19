// Fill out your copyright notice in the Description page of Project Settings.


#include "HealthSystem.h"

UHealthSystem::UHealthSystem()
{
	PrimaryComponentTick.bCanEverTick = false;
	MaxHealth = 100.0f;
	CurrentHealth = MaxHealth;
	bIsDead = false;
	bIsPlayerDead = false;
}

void UHealthSystem::BeginPlay()
{
	Super::BeginPlay();

	MaxHealth = FMath::Max(0.0f, MaxHealth);
	CurrentHealth = FMath::Clamp(CurrentHealth, 0.0f, MaxHealth);
	HandleHealthUpdated(CurrentHealth);
}

void UHealthSystem::HandleHealthUpdated(float PreviousHealth)
{
	const bool bWasDead = bIsDead;
	const bool bShouldBeDead = CurrentHealth <= 0.0f;

	bIsDead = bShouldBeDead;
	bIsPlayerDead = bShouldBeDead;

	const float Delta = CurrentHealth - PreviousHealth;
	OnHealthChanged.Broadcast(this, CurrentHealth, MaxHealth, Delta);

	if (!bWasDead && bShouldBeDead)
	{
		OnDeath.Broadcast(this);
	}
}

void UHealthSystem::AddHealth(float Amount)
{
	if (Amount <= 0.0f || bIsDead)
	{
		return;
	}

	SetHealth(CurrentHealth + Amount);
}

void UHealthSystem::RemoveHealth(float Amount)
{
	if (Amount <= 0.0f || bIsDead)
	{
		return;
	}

	SetHealth(CurrentHealth - Amount);
}

void UHealthSystem::SetHealth(float NewHealth)
{
	const float PreviousHealth = CurrentHealth;
	CurrentHealth = FMath::Clamp(NewHealth, 0.0f, MaxHealth);

	if (FMath::IsNearlyEqual(PreviousHealth, CurrentHealth))
	{
		return;
	}

	HandleHealthUpdated(PreviousHealth);
}

float UHealthSystem::GetHealth() const
{
	return CurrentHealth;
}

float UHealthSystem::GetMaxHealth() const
{
	return MaxHealth;
}

bool UHealthSystem::IsDead() const
{
	return bIsDead;
}

bool UHealthSystem::IsPlayerDead() const
{
	return bIsPlayerDead;
}

